when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, M:int, U:seq[int], V:seq[int], K:int, x:seq[int]):
  Pred U, V, x
  var
    s = x.toSet
    uf = initDSU(N)
  for ei in M:
    if ei in s: continue
    uf.merge(U[ei], V[ei])
  var leaders = initSet[int]()
  for u in N:
    leaders.incl(uf.leader(u))
  var deg = Seq[N: 0]
  for i in x:
    var
      u = uf.leader(U[i])
      v = uf.leader(V[i])
    deg[u].inc
    deg[v].inc
  odd := 0
  for u in leaders:
    if deg[u] mod 2 == 1: odd.inc
  if odd == 0 or odd == 2:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
  var K = nextInt()
  var x = newSeqWith(K, nextInt())
  solve(N, M, U, V, K, x)
else:
  discard

