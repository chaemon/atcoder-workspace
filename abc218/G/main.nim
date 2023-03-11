const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/graph/graph_template
import lib/other/binary_search

solveProc solve(N:int, A:seq[int], u:seq[int], v:seq[int]):
  var g = initGraph[int](N)
  for i in N - 1: g.addBiEdge(u[i], v[i])
  proc calc(K:int):(int, int) =
    # 戻り値: K以上なら+1, K未満なら-1にした和, K未満の値の最大値
    var K = K * 2
    proc dfs(u, p, h:int):(int, int) =
      var s0, m0:int
      isLeaf := false
      if h mod 2 == 0:
        s0 = -int.inf # 太郎くんはs0を大きくしたい
        m0 = -int.inf # 同立の場合はm0を最大化
        for e in g[u]:
          if e.dst == p: continue
          var (s, m) = dfs(e.dst, u, h + 1)
          if s0 < s:
            s0 = s
            m0 = m
          elif s0 == s:
            m0.max=m
        if s0 == -int.inf:
          isLeaf = true
      else:
        s0 = int.inf # 次郎くんはs0を小さくしたい
        m0 = int.inf # 同立の場合はm0を最小化
        for e in g[u]:
          if e.dst == p: continue
          var (s, m) = dfs(e.dst, u, h + 1)
          if s0 > s:
            s0 = s
            m0 = m
          elif s0 == s:
            m0.min=m
        if s0 == int.inf:
          isLeaf = true
      if isLeaf:
        if A[u] >= K:
          s0 = 1
          m0 = -int.inf
        else:
          s0 = -1
          m0 = A[u]
      else:
        if A[u] >= K:
          s0.inc
        else:
          s0.dec
          m0.max=A[u]
      return (s0, m0)
    return dfs(0, -1, 0)
  let M = A.max div 2
  proc f(K:int):bool =
    calc(K)[0] >= 0
  let
    K0 = f.maxRight(0 .. M)
  var (s, m) = calc(K0)
  doAssert s >= 0
  if s > 0:
    echo K0 * 2
  else:
    echo (K0 * 2 + m) div 2
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, A, u.pred, v.pred)
else:
  discard

