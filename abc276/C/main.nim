when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, P:seq[int]):
  var P = P
  P.prevPermutation
  echo P.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  discard

