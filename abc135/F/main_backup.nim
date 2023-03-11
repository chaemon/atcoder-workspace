#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

#{{{ Knuth-Morris-Pratt
proc buildFail(p:string):seq[int] =
  var
    m = p.len
    fail = newSeq[int](m+1)
    j = -1
  fail[0] = -1
  for i in 1..m:
    while j >= 0 and p[j] != p[i-1]: j = fail[j]
    fail[i] = j
    j += 1
  return fail

proc match(t,p:string, fail:seq[int]):seq[int] =
  var
    n = t.len
    m = p.len
    k = 0
  result = newSeq[int]()
  for i in 0..<n:
    while k >= 0 and p[k] != t[i]: k = fail[k]
    k += 1
    if k >= m:
      # match at t[i-m+1 .. i]
#      count += 1 
      result.add(i-m+1)
      k = fail[k]
#}}}

#{{{ suffix Array
type SuffixArray = object
  t:string
  sa:seq[int]
  lcp:seq[int]
  rmq:seq[int]

# Larsson-Sadakane's Suffix array Construction: O(n (log n)^2)
proc newSuffixArray(t:string): SuffixArray =
  var
    n = t.len
    g = newSeq[int](n+1)
    b = newSeq[int](n+1)
    v = newSeq[int](n+1);
  for i in 0..n:
    v[i] = i
    g[i] = if i < n: ord(t[i]) else: 0
  b[0] = 0; b[n] = 0
  var h = 0
  proc cmp(a,b:int):int =
    return 
      if a == b: 0
      else:
        if g[a] != g[b]: system.cmp[int](g[a], g[b])
        else: system.cmp[int](g[a+h], g[b+h])
  v.sort(cmp)
  h = 1
  while b[n] != n:
    v.sort(cmp)
    for i in 0..<n:
      b[i+1] = b[i] + (if cmp(v[i],v[i+1]) == -1: 1 else: 0)
    for i in 0..n:
      g[v[i]] = b[i]
    h *= 2
  return SuffixArray(t:t,sa:v)

proc strncmp(s:string, i:int, t:string, j:int, n:int):int =
  if n == 0:
    return 0
  elif i >= s.len:
    if j >= t.len:
      return 0
    else:
      return -1
  elif j >= t.len:
    return 1
  elif s[i] != t[j]:
    return system.cmp[char](s[i],t[j])
  else:
    return strncmp(s,i+1,t,j+1,n-1)

#// Naive matching O(m log n)

proc find(self:SuffixArray, p:string):int =
  var
    a = 0
    b = self.t.len
  while a < b:
    var c = (a + b) div 2
#    if (strncmp(t+sa[c], p, m) < 0) a = c+1; else b = c;
    if strncmp(self.t, self.sa[c], p, 0, p.len) < 0: a = c + 1
    else: b = c
  return if strncmp(self.t, self.sa[a], p, 0, p.len) == 0: self.sa[a] else: -1

# Kasai-Lee-Arimura-Arikawa-Park's simple LCP computation: O(n)
proc buildLCP(self:var SuffixArray):void =
  var
    h = 0
    n = self.t.len
    b = newSeq[int](n+1)
  self.lcp = newSeq[int](n+1)
  for i in 0..n: b[self.sa[i]] = i
  for i in 0..n:
    if b[i] > 0:
      var j = self.sa[b[i]-1]
      while j+h < n and i+h < n and self.t[j+h] == self.t[i+h]: h += 1
      self.lcp[b[i]] = h;
    else: self.lcp[b[i]] = -1
    if h > 0: h -= 1

# call RMQ = buildRMQ(lcp, n+1)
proc buildRMQ(self:var SuffixArray):void =
  var
    logn = 1
    n = self.t.len
    k = 1
  while k < n:
    k *= 2
    logn += 1
  var
    base = 0
#    N = self.lcp.len
    N = n
  self.rmq = newSeq[int](N * logn)
  for i in 0..<N:
    self.rmq[base + i] = self.lcp[i]
  k = 1
#  for _ in 1..<logn:
  while k < n:
    for i in 0..<N:
      self.rmq[base + N + i] = self.rmq[base + i]
    base += N
    for i in 0..<N - k: self.rmq[base + i] = min(self.rmq[base + i], self.rmq[base + i + k])
    k *= 2
# inner LCP computation with RMQ: O(1)
proc minimum(self:SuffixArray, x,y:int):int =
  var
    n = self.t.len
    z = y - x
    k = 0
    e = 1
    s:int # y - x >= e = 2^k なる最大 k
  s = (if (z and 0xffff0000) != 0: 1 else: 0 ) shl 4; z = (z shr s); e = (e shl s);k = (k or s)
  s = (if (z and 0x0000ff00) != 0: 1 else: 0 ) shl 3; z = (z shr s); e = (e shl s);k = (k or s)
  s = (if (z and 0x000000f0) != 0: 1 else: 0 ) shl 2; z = (z shr s); e = (e shl s);k = (k or s)
  s = (if (z and 0x0000000c) != 0: 1 else: 0 ) shl 1; z = (z shr s); e = (e shl s);k = (k or s)
  s = (if (z and 0x00000002) != 0: 1 else: 0 ) shl 0; z = (z shr s); e = (e shl s);k = (k or s)
  return min( self.rmq[x+n*k], self.rmq[y+n*k-e+1] )

# outer LCP computation: O(m - o)
proc computeLCP(self:SuffixArray, p:string, o,k:int):int =
  var i = o
  while i < p.len and k+i < self.t.len and p[i] == self.t[k+i]: i += 1
  return i
# Mamber-Myers's O(m + log n) string matching with LCP/RMQ
proc find2(self:SuffixArray, p:string):int =
  var
    n = self.t.len
    l = 0
    lh = 0
    r = n
    rh = self.computeLCP(p,0,self.sa[n])
  proc COMP(h,k:int):bool =
    return h == p.len or (k + h < n and p[h] < self.t[k+h])
  if not COMP(rh, self.sa[r]): return -1
  while l + 1 < r:
    var
      k = (l + r) div 2
      A = self.minimum(l+1, k)
      B = self.minimum(k+1, r)
    if A >= B:
      if lh < A: l = k
      elif lh > A: r = k; rh = A
      else:
        var i = self.computeLCP(p, A, self.sa[k])
        if COMP(i, self.sa[k]): r = k; rh = i
        else: l = k;lh = i
    else:
      if rh < B: r = k
      elif rh > B: l = k; lh = B
      else:
        var i = self.computeLCP(p, B, self.sa[k])
        if COMP(i, self.sa[k]): r = k; rh = i
        else: l = k; lh = i
  return if rh == p.len: self.sa[r] else: -1
#}}}

proc main():void =
  var
    s,t = nextString()
    n = s.len
  while s.len < n + t.len:
    s.add(s)
#  var
#    fail = buildFail(t)
#    v = match(s,t,fail)
  var sa = newSuffixArray(s)
  sa.buildLCP()
  sa.buildRMQ()
  var
    k = sa.find2(t)
  if k == -1:
    echo 0
    return
  var b = 0
  while sa.sa[b] != k: b += 1
  var
    jump = newSeq[bool](n)
  while true:
    var i = sa.sa[b]
    if i < n: jump[i] = true
#    if sa.minimum(b+1,b+1) < t.len: break
    if sa.minimum(b+1,b+1) < t.len: break
    b += 1
  echo jump
  var
    vis = newSeqWith(n,false)
    ans = 0
  for i in 0..<n:
    if vis[i]: continue
    var
      j = i
      a = newSeq[bool]()
    while true:
      vis[j] = true
      a.add(jump[j])
      j += t.len
      j = j mod n
      if j == i: break
    var
      start = -1
    for i in 0..<a.len:
      if not a[i]: start = i
    if start == -1:
      echo -1
      return
    var i = start
    while true:
      var
        j = i
        end_loop = false
      while not a[j]:
        j += 1
        if j == n: j = 0
        if j == start:
          end_loop = true
          break
      if end_loop:
        break
      assert a[j]
      var
        k = j
        ct = 0
      while a[k]:
        ct += 1
        k += 1
        if k == n: k = 0
      assert not a[k]
      ans = max(ans,ct)
      i = k
      if i == start:
        break
  echo ans

main()


