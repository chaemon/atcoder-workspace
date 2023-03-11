#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils
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

proc discardableId[T](x: T): T {.discardable.} = return x
template `:=`(x, y: untyped): untyped =
  when defined(x):
    (x = y; discardableId(x))
  else:
    (var x = y; discardableId(x))
#}}}

proc lt_substr(s:string, t:string, si:int = 0,ti:int = 0):bool =
  var
    sn = s.len
    tn = t.len
    si = si
    ti = ti
  while si < sn and ti < tn:
    if s[si] < t[ti]: return true
    if s[si] > t[ti]: return false
    si += 1; ti += 1
  return si >= sn and ti < tn

#{{{ Knuth-Morris-Pratt match(t, pattern)
proc match(t,p:string):seq[int] =
  proc buildFail(p:string):seq[int] =
    let m = p.len
    var fail = newSeq[int](m+1)
    var j = -1
    fail[0] = -1;
    for i in 1..m:
      while j >= 0 and p[j] != p[i - 1]: j = fail[j]
      j += 1
      fail[i] = j
    return fail
  let
    fail = buildFail(p)
    n = t.len
    m = p.len
  result = newSeq[int]()
  var k = 0
  for i in 0..<n:
    while k >= 0 and p[k] != t[i]: k = fail[k]
    k += 1
    if k >= m:
      result.add(i - m + 1) # match at t[i-m+1 .. i]
      k = fail[k]
#}}}

proc main():void =
  var
    s,t = nextString()
    n = s.len
  while s.len < n + t.len:
    s.add(s)
  jump := newSeqWith(n,false)
  v := s.match(t)
  for a in v:
    if a < n: jump[a] = true
#  var sa = newSuffixArray(s)
#  var
#    p = sa.lowerUpperBound(t)
#  if p[0] >= p[1]:
#    echo 0
#    return
#  for i in p[0]..<p[1]:
#    var j = sa.SA[i]
#    if j < n: jump[j] = true
#  var
#    vis = newSeqWith(n,false)
#  for ii in 0..<n:
#    if vis[ii]: continue
#    var
#      j = ii
#      a = newSeq[bool]()
#    while true:
#      vis[j] = true
#      a.add(jump[j])
#      j += t.len
#      j = j mod n
#      if j == ii: break
#    var
#      start = -1
#    for i in 0..<a.len:
#      if not a[i]: start = i
#    if start == -1:
#      echo -1
#      return
  dp := newSeqWith(n, -1)
  proc calc(i:int):int =
    if dp[i] >= 0: return dp[i]
    if dp[i] == -2: return int.infty
    dp[i] = -2
    if not jump[i]:
      dp[i] = 0
    else:
      i2 := (i + t.len) mod n
      t := calc(i2)
      if t == int.infty: dp[i] = int.infty
      else: dp[i] = t + 1
    return dp[i]
  ans := 0
  for i in 0..<n:
    ans = max(ans, calc(i))
  echo if ans == int.infty: -1 else: ans

main()


