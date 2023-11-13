when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/extra/graph/maxflow_lowerbound

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, M:int, A:int, B:int, C:int, U:seq[int], V:seq[int]):
  # N(入), N(出),
  Pred A, B, C, U, V
  var g = initMaxFlowLowerBound[int](N * 2)
  let
    s = A
    t = C + N
  for u in N:
    if u == B:
      g.addEdge(u, u + N, 1, 1)
    else:
      g.addEdge(u, u + N, 0, 1)
  for i in M:
    g.addEdge(U[i] + N, V[i], 0, 1)
    g.addEdge(V[i] + N, U[i], 0, 1)
  if g.canFlow(s, t):
    echo YES
  else:
    echo NO
  debug g.maxFlow(s, t)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, M, A, B, C, U, V)
else:
  discard

