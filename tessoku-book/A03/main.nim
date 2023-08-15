when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, K:int, P:seq[int], Q:seq[int]):
  for i in N:
    for j in N:
      if P[i] + Q[j] == K:
        echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, nextInt())
  var Q = newSeqWith(N, nextInt())
  solve(N, K, P, Q)
else:
  discard

