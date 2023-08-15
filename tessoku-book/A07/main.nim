when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum

solveProc solve(D:int, N:int, L:seq[int], R:seq[int]):
  Pred L
  var cs = initDualCumulativeSum[int](D)
  for i in N:
    cs.add(L[i] ..< R[i], 1)
  for i in D:
    echo cs[i]
  discard

when not defined(DO_TEST):
  var D = nextInt()
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(D, N, L, R)
else:
  discard

