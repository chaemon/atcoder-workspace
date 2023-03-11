# header {{{
{.hints:off checks:off warnings:off assertions:on optimization:speed.}
import algorithm
import sequtils
import tables
import macros
import math
import sets
import strutils
import strformat
import sugar
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc discardableId[T](x: T): T {.discardable.} =
  return x

macro `:=`(x, y: untyped): untyped =
  var strBody = ""
  if x.kind == nnkPar:
    for i,xi in x:
      strBody &= fmt"""
{xi.repr} := {y[i].repr}
"""
  else:
    strBody &= fmt"""
when declaredInScope({x.repr}):
  {x.repr} = {y.repr}
else:
  var {x.repr} = {y.repr}
"""
  strBody &= fmt"discardableId({x.repr})"
  parseStmt(strBody)


proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

template makeSeq(x:int; init):auto =
  when init is typedesc: newSeq[init](x)
  else: newSeqWith(x, init)

macro Seq(lens: varargs[int]; init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")

template makeArray(x:int; init):auto =
  var v:array[x, init.type]
  when init isnot typedesc:
    for a in v.mitems: a = init
  v

macro Array(lens: varargs[typed], init):untyped =
  var a = fmt"{init.repr}"
  for i in countdown(lens.len - 1, 0):
    a = fmt"makeArray({lens[i].repr}, {a})"
  parseStmt(fmt"""
block:
  {a}""")
#}}}

var S:string

# input part {{{
proc main()
block:
  S = nextString()
#}}}

when true:
  const ATCODER_STRING_HPP = 1

  import algorithm
  import strutils
  import sequtils

  proc sa_naive(s:seq[int]):seq[int] =
    let n = s.len
    var sa = newSeq[int](n)
    for i in 0..<n:sa[i] = i
    sa.sort() do (l, r:int) -> int:
      if l == r: return 0
      var (l, r) = (l, r)
      while l < n and r < n:
        if s[l] != s[r]: return cmp[int](s[l], s[r])
        l.inc;r.inc
      return cmp[int](n, l)
    return sa
  
  proc sa_doubling(s:seq[int]):seq[int] =
    let n = s.len
    var
      sa, tmp = newSeq[int](n)
      rnk = s
    for i in 0..<n:sa[i] = i
    var k = 1
    while k < n:
      proc cmp0(x, y:int):int =
        if rnk[x] != rnk[y]: return cmp[int](rnk[x], rnk[y])
        let
          rx = if x + k < n: rnk[x + k] else: -1
          ry = if y + k < n: rnk[y + k] else: -1
        return cmp[int](rx, ry)
      sa.sort(cmp0)
      tmp[sa[0]] = 0
      for i in 1..<n:
        tmp[sa[i]] = tmp[sa[i - 1]] + (if cmp0(sa[i - 1], sa[i]) < 0: 1 else: 0)
      swap(tmp, rnk)
      k = k shl 1
    return sa

  # SA-IS, linear-time suffix array construction
  # Reference:
  # G. Nong, S. Zhang, and W. H. Chan,
  # Two Efficient Algorithms for Linear Time Suffix Array Construction
#  template <int THRESHOLD_NAIVE = 10, int THRESHOLD_DOUBLING = 40>
  proc sa_is[THRESHOLD_NAIVE:static[int], THRESHOLD_DOUBLING:static[int]](s:seq[int], upper:int):seq[int] =
    let n = s.len
    if n == 0: return @[]
    if n == 1: return @[0]
    if n == 2:
      if s[0] < s[1]:
        return @[0, 1]
      else:
        return @[1, 0]
    if n < THRESHOLD_NAIVE:
      return sa_naive(s)
    if n < THRESHOLD_DOUBLING:
      return sa_doubling(s)
    
    var sa, ls = newSeq[int](n)
    for i in countdown(n - 2, 0):
      ls[i] = if s[i] == s[i + 1]: ls[i + 1] else: (s[i] < s[i + 1]).int
    var sum_l, sum_s = newSeq[int](upper + 1)
    for i in 0..<n:
      if ls[i] == 0:
        sum_s[s[i]].inc
      else:
        sum_l[s[i] + 1].inc
    for i in 0..upper:
      sum_s[i] += sum_l[i]
      if i < upper: sum_l[i + 1] += sum_s[i]

    proc induce(lms:seq[int]):auto =
      sa.fill(-1)
      var buf = sum_s
      for d in lms:
        if d == n: continue
        sa[buf[s[d]]] = d
        buf[s[d]].inc
      buf = sum_l
      sa[buf[s[n - 1]]] = n - 1
      buf[s[n - 1]].inc
      for i in 0..<n:
        let v = sa[i]
        if v >= 1 and ls[v - 1] == 0:
          sa[buf[s[v - 1]]] = v - 1
          buf[s[v - 1]].inc
      buf = sum_l
      for i in countdown(n - 1, 0):
        let v = sa[i]
        if v >= 1 and ls[v - 1] != 0:
          buf[s[v - 1] + 1].dec
          sa[buf[s[v - 1] + 1]] = v - 1
  
    var lms_map = newSeqWith(n + 1, -1)
    var m = 0
    for i in 1..<n:
      if ls[i - 1] == 0 and ls[i] != 0:
        lms_map[i] = m
        m.inc
    var lms = newSeqOfCap[int](m)
    for i in 1..<n:
      if ls[i - 1] == 0 and ls[i] != 0:
        lms.add(i)
  
    induce(lms)
  
    if m != 0:
      var sorted_lms = newSeqOfCap[int](m)
      for v in sa:
        if lms_map[v] != -1: sorted_lms.add(v)
      var
        rec_s = newSeq[int](m)
        rec_upper = 0;
      rec_s[lms_map[sorted_lms[0]]] = 0
      for i in 1..<m:
        var (l, r) = (sorted_lms[i - 1], sorted_lms[i])
        let
          end_l = if lms_map[l] + 1 < m: lms[lms_map[l] + 1] else: n
          end_r = if lms_map[r] + 1 < m: lms[lms_map[r] + 1] else: n
        var same = true
        if end_l - l != end_r - r:
          same = false
        else:
          while l < end_l:
            if s[l] != s[r]:
              break
            l.inc
            r.inc
          if l == n or s[l] != s[r]: same = false
        if not same: rec_upper.inc
        rec_s[lms_map[sorted_lms[i]]] = rec_upper

      let rec_sa =
        sa_is[THRESHOLD_NAIVE, THRESHOLD_DOUBLING](rec_s, rec_upper)

      for i in 0..<m:
        sorted_lms[i] = lms[rec_sa[i]]
      induce(sorted_lms)
    return sa

# namespace internal
  
  proc suffix_array*(s:seq[int], upper:int):seq[int] =
    assert 0 <= upper
    for d in s:
      assert 0 <= d and d <= upper
    return sa_is[10, 40](s, upper)
  
  proc suffix_array*[T](s:seq[T]):seq[int] =
    let n = s.len
    var idx = newSeq[int](n)
    for i in 0..<n: idx[i] = i
    idx.sort(proc(l,r:int):int = cmp[int](s[l], s[r]))
    var s2 = newSeq[int](n)
    var now = 0
    for i in 0..<n:
      if i != 0 and s[idx[i - 1]] != s[idx[i]]: now.inc
      s2[idx[i]] = now
    return sa_is[10, 40](s2, now)
  
  proc suffix_array*(s:string):seq[int] =
    return sa_is[10, 40](s.mapIt(it.int), 255);
  
  # Reference:
  # T. Kasai, G. Lee, H. Arimura, S. Arikawa, and K. Park,
  # Linear-Time Longest-Common-Prefix Computation in Suffix Arrays and Its
  # Applications
  proc lcp_array*[T](s:seq[T], sa:seq[int]):seq[int] =
    let n = s.len
    assert n >= 1
    var rnk = newSeq[int](n)
    for i in 0..<n:
      rnk[sa[i]] = i
    var lcp = newSeq[int](n - 1)
    var h = 0;
    for i in 0..<n:
      if h > 0: h.dec
      if rnk[i] == 0: continue
      let j = sa[rnk[i] - 1]
      while j + h < n and i + h < n:
        if s[j + h] != s[i + h]: break
        h.inc
      lcp[rnk[i] - 1] = h
    return lcp
  
  proc lcp_array*(s:string, sa:seq[int]):seq[int] = lcp_array(s.mapIt(it.int), sa)
  
  # Reference:
  # D. Gusfield,
  # Algorithms on Strings, Trees, and Sequences: Computer Science and
  # Computational Biology
  proc z_algorithm*[T](s:seq[T]):seq[T] =
    let n = s.len
    if n == 0: return @[]
    var z = newSeq[int](n)
    z[0] = 0
    var j = 0
    for i in 1..<n:
      var k = z[i].addr
      k[] = if j + z[j] <= i: 0 else: min(j + z[j] - i, z[i - j])
      while i + k[] < n and s[k[]] == s[i + k[]]: k[].inc
      if j + z[j] < i + z[i]: j = i
    z[0] = n
    return z

  proc z_algorithm*(s:string):auto = z_algorithm(s.mapIt(it.int))

# namespace atcoder

  discard
import "math"
when true:
  const ATCODER_SCC_HPP = 1

  import sequtils
  when true:
    const ATCODER_INTERNAL_SCC_HPP = 1
    
    import sequtils
    
    type csr[E] = object
      start:seq[int]
      elist:seq[E]
    proc initCsr[E](n:int, edges:seq[(int,E)]):auto =
      var
        start = newSeq[int](n + 1)
        elist = newSeq[E](edges.len)
      for e in edges:
        start[e[0] + 1].inc
      for i in 1..n:
        start[i] += start[i - 1]
      var counter = start
      for e in edges:
        elist[counter[e[0]]] = e[1]
        counter[e[0]].inc
      return csr[E](start:start, elist:elist)
    
    type edge = object
      dst:int
    # Reference:
    # R. Tarjan,
    # Depth-First Search and Linear Graph Algorithms
    type internal_scc_graph* = object
      n:int
      edges:seq[(int,edge)]
  
    proc init_internal_scc_graph*(n:int):auto = internal_scc_graph(n:n, edges:newSeq[(int,edge)]())
    
    proc num_vertices*(self: internal_scc_graph):int =  self.n
  
    proc add_edge*(self: var internal_scc_graph, src, dst:int) = self.edges.add((src, edge(dst:dst)))
  
    # @return pair of (# of scc, scc id)
    proc scc_ids*(self: internal_scc_graph):(int,seq[int]) =
      var g = initCsr[edge](self.n, self.edges)
      var now_ord, group_num = 0
      var
        visited = newSeqOfCap[int](self.n)
        low = newSeq[int](self.n)
        ord = newSeqWith(self.n, -1)
        ids = newSeq[int](self.n)
      proc dfs(v:int) =
        low[v] = now_ord
        ord[v] = now_ord
        now_ord.inc
        visited.add(v)
        for i in g.start[v] ..< g.start[v + 1]:
          let dst = g.elist[i].dst
          if ord[dst] == -1:
            dfs(dst)
            low[v] = min(low[v], low[dst])
          else:
            low[v] = min(low[v], ord[dst])
        if low[v] == ord[v]:
          while true:
            let u = visited[^1]
            discard visited.pop()
            ord[u] = self.n
            ids[u] = group_num
            if u == v: break
          group_num.inc
      for i in 0..<self.n:
        if ord[i] == -1: dfs(i)
      ids.applyIt(group_num - 1 - it)
      return (group_num, ids)
  
    proc scc*(self: internal_scc_graph):auto =
      let
        ids = self.scc_ids()
        group_num = ids[0]
      var counts = newSeq[int](group_num)
      for x in ids[1]: counts[x].inc
      result = newSeq[seq[int]](ids[0])
      for i in 0..<group_num:
        result[i] = newSeqOfCap[int](counts[i])
      for i in 0..<self.n:
        result[ids[1][i]].add(i)
    discard

  type scc_graph = object
    internal: internal_scc_graph

  proc initSccGraph(n:int):auto = init_internal_scc_graph(n)
  
  proc add_edge(self:var scc_graph, src, dst:int) =
    let n = self.internal.num_vertices()
    assert 0 <= src and dst < n
    assert 0 <= dst and dst < n
    self.internal.add_edge(src, dst)

  proc scc(self:scc_graph):auto = self.internal.scc()
  discard

proc main() =
  let
    N = S.len
    sa = S.suffixArray()
    lcp = S.lcp_array(sa)
  echo N * (N + 1) div 2 - lcp.sum
  return

main()

