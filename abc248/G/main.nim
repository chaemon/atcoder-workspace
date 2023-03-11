const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/graph_template

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc `+=`(p:var (int, int), q:(int, int)) =
  p[0] += q[0]
  p[1] += q[1]

solveProc solve(N:int, A:seq[int], U:seq[int], V:seq[int]):
  var G = initGraph[int](N)
  for i in N - 1:
    G.addBiEdge(U[i], V[i])
  var ans = mint(0)
  proc dfs(u, p:int):seq[(int, tuple[n, s:int])] =
    var result0 = initTable[int, tuple[n, s:int]]()
    for e in G[u]:
      if e.dst == p: continue
      var t = dfs(e.dst, u)
      for (g, pr) in t:
        let (n, s) = pr
        for g0, (n0, s0) in result0:
          var g0 = gcd(g, g0)
          ans += mint(g0) * (mint(s) * n0 + mint(s0) * n)
      for (g, pr) in t.mitems:
        pr.s += pr.n
      for (g, pr) in t:
        var g = gcd(g, A[u])
        if g notin result0:
          result0[g] = (0, 0)
        result0[g] += pr
    for g, (n, s) in result0:
      ans += mint(g) * s
    if A[u] notin result0: result0[A[u]] = (0, 0)
    result0[A[u]] += (1, 1)
    for k, v in result0:
      result.add((k, v))
  discard dfs(0, -1)
  echo ans
  Naive:
    var ans = mint(0)
    var G = initGraph[int](N)
    for i in N - 1:
      G.addBiEdge(U[i], V[i])
    proc dfs(u, p, g, s:int) =
      var g = gcd(g, A[u])
      if s >= 2:
        ans += mint(g) * s
      for e in G[u]:
        if e.dst == p: continue
        dfs(e.dst, u, g, s + 1)
    for u in N:
      dfs(u, -1, 0, 1)
    ans /= 2
    echo ans
  discard


when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var U = newSeqWith(N-1, 0)
  var V = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  #test(N, A, U, V)
  solve(N, A, U, V)
else:
  var
    U = @[1, 2, 3, 4]
    V = @[2, 3, 4, 5]
