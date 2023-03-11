include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/cycle_detection
#import atcoder/extra/tree/doubling_lowest_common_ancestor
import atcoder/extra/tree/heavy_light_decomposition
import atcoder/extra/dp/cumulative_sum
import atcoder/lazysegtree
#import atcoder/extra/structure/universal_segtree

const DEBUG = true

op(a, b:int) => a + b
mapping(f:bool, a:int) => (if f: 1 else: a)
composition(f, g:bool) => f or g

proc solve(N, M:int, A, C, X, Y:seq[int]):int =
  var st = initLazySegTree(N + 1, op, () => 0, mapping, composition, () => false)
  var g = initGraph[int](N)
  for i in 0..<N:
    g.addBiEdge(i, A[i], C[i])
  let c0 = g.cycle_detection_undirected()
  assert c0.isSome
  let c = c0.get
  var cycle = initTable[int, int]()
  for i,e in c: cycle[e.src] = i
  assert cycle.len >= 2
  var non_cycle_edge:seq[(int, int, int)]
  var g2 = initGraph[int](N + 1)
  for u, i in cycle:
    g2.addBiEdge(u, N)
  for i in 0..<N:
    let (u, v) = (i, A[i])
    if u in cycle and v in cycle: continue
    g2.addBiEdge(u, v)
    non_cycle_edge.add((u, v, C[i]))
  var cycle_query: seq[(int, int)]
#  var dlca = g2.initDoublingLowestCommonAncestor(N)
  var hld = g2.initHeavyLightDecomposition(N)
  q(a, b:int) => st.apply(a..<b, true)
  for i in 0..<M:
    let (x, y) = (X[i], Y[i])
    let
      x1 = hld.la(x, hld.dep[x] - 1)
      y1 = hld.la(y, hld.dep[y] - 1)
#    let
#      x1 = dlca.ancestor(x, 1)
#      y1 = dlca.ancestor(y, 1)
    let d = hld.lca(x, y)
#    let d = dlca.lca(x, y)
    if d != N:
      hld.add(x, y, q, true)
    else:
      hld.add(x, x1, q, true)
      hld.add(y, y1, q, true)
      cycle_query.add((cycle[x1], cycle[y1]))
  var ans = 0
  for (u, v, c) in non_cycle_edge:
    ans += hld.query(u, v, 0, (a, b:int) => st[a..<b], (a, b:int) => a + b, true) * c
  var ans2 = int.inf
  block:
    let n = c.len
    var ans_a = Seq[2, n: int]
    type S = tuple[s, S:int]
    for ct in 2:
      var
        cs = initCumulativeSum(n + 1, int)
        st2 = initLazySegTree(n + 1, (a, b:S) => (a.s + b.s, a.S + b.S), () => (0, 0), (f:bool, a:S) => (if f: (a.S, a.S) else: a), (f, g:bool) => f or g, () => false)
        st = initLazySegTree(n + 1, (a, b:int) => min(a, b), () => int.inf, (f, a:int) => f + a, (f, g:int) => f + g, () => 0)
        segs = Seq[n + 1: seq[(int, int, int)]]
      if ct == 0:
        for i, e in c:
          cs[i] = e.weight
          st2[i] = (0, e.weight)
        for (x, y) in cycle_query:
          var (x, y) = (x, y)
          if x > y: swap(x, y)
          segs[x].add((1, x, y))
          segs[y].add((-1, x, y))
      else:
        for i, e in c:
          cs[n - 1 - i] = e.weight
          st2[n - 1 - i] = (0, e.weight)
        for (x, y) in cycle_query:
          var (x, y) = (x, y)
          if x > y: swap(x, y)
          (x, y) = (n - y, n - x)
          assert x <= y
          segs[x].add((1, x, y))
          segs[y].add((-1, x, y))
      var
        k = 0
        s = 0
      for i in 0..n:
        st[i] = 0
      for i in 0..<n:
        for (t, x, y) in segs[i]:
          k += t
          if t == 1:
            st.apply(x..<y, 1)
          elif t == -1:
            st.apply(x..<y, -1)
            st2.apply(x..<y, true)
          else: assert(false)
        if k > 0:
          s += cs[i..i]
          let l = st.minLeft(i, (a:int) => a >= k)
          assert(l - 1 < 0 or st[l - 1] < k)
          assert(st[l] == k)
          ans_a[ct][i] = cs[0..<l] + st2[l..<i].s
        else:
          ans_a[ct][i] = int.inf
      ans2.min=s
    ans_a[1].reverse
    for i in 0..<n: ans2.min=ans_a[0][i] + ans_a[1][i]
  ans += ans2
  return ans

import atcoder/extra/other/bitutils
import std/bitops

proc solve_naive(N, M:int, A, C, X, Y:seq[int]):int =
  proc valid(b, X, Y:int):bool =
    var (X, Y) = (X, Y)
    for i in 0..<2:
      var found = true
      var i = X
      while i != Y:
        if not b[i]: found = false;break
        i.inc
        if i == N: i = 0
      if found: return true
      swap X, Y
    return false
  result = int.inf
  for b in 0..<2^N:
    var found = true
    for i in 0..<M:
      if not valid(b, X[i], Y[i]): found = false;break
    if found:
      var s = 0
      for i in 0..<N:
        if b[i]: s += C[i]
      result.min=s

const TEST = false

when TEST:
#  block test:
#    let N = 5
#    let M = 3
#    let A = @[1, 2, 3, 4, 0]
#    let C = 1.repeat(N)
#    let X = @[0, 1, 0]
#    let Y = @[1, 2, 4]
#    let s0 = solve(N, M, A, C, X, Y)
#    let s1 = solve_naive(N, M, A, C, X, Y)
#    echo s0, " ", s1

    let N = 10
    let M = 3
    var A = Seq[N: int]
    var C = Seq[N: 1]
    var X, Y = Seq[M: int]
    for i in 0..<N:
      A[i] = i + 1
      if A[i] == N: A[i] = 0
    for x0 in 0..<N:
      for y0 in x0+1..<N:
        for x1 in 1..<N:
          for y1 in x1+1..<N:
            for x2 in 0..<N:
              for y2 in x2+1..<N:
                X = @[x0, x1, x2]
                Y = @[y0, y1, y2]
                echo N," ", M," ", A, C, X, Y
                let s0 = solve(N, M, A, C, X, Y)
                let s1 = solve_naive(N, M, A, C, X, Y)
                if s0 != s1:
                  echo "different: ", s0, " ", s1
                  assert false


else:
  block main:
    let N, M = nextInt()
    let (A, C) = unzip(N, (nextInt() - 1, nextInt()))
    let (X, Y) = unzip(M, (nextInt() - 1, nextInt() - 1))
    echo solve(N, M, A, C, X, Y)
