when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/dp/cumulative_sum

solveProc solve(N:int, Q:int, A:seq[int], L:seq[int], R:seq[int]):
  Pred L
  var cs = initCumulativeSum[int](N)
  for i in N:
    cs[i] = A[i]
  for i in Q:
    echo cs[L[i] ..< R[i]]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, Q, A, L, R)
else:
  discard

