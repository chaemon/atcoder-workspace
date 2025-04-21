when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/scc

solveProc solve(N:int, M:int, P:seq[int], U:seq[int], V:seq[int], W:seq[float]):
  Pred U, V
  var
    g = initSCCGraph(N)
    adj = Seq[N: seq[tuple[u:int, w:float]]]
  for i in M:
    # U[i] -> V[i]の逆の辺
    g.addEdge(V[i], U[i])
    adj[V[i]].add (U[i], W[i])
  var
    s = g.scc
    a = Seq[N: -float.inf]
  a[N - 1] = 0.0
  for u in s:
    doAssert u.len == 1
    let u = u[0]
    if a[u] == -float.inf: continue
    # uの得点がpのとき
    a[u] += float(P[u])
    for (v, w) in adj[u]:
      a[v].max=a[u] * w
  if a[0] == -float.inf:
    echo -1
  else:
    echo a[0]
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = newSeqWith(N, nextInt())
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  var W = newSeqWith(M, 0.0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
    W[i] = nextFloat()
  solve(N, M, P, U, V, W)
else:
  discard

