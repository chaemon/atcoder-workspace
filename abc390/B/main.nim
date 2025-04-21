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
solveProc solve(N:int, A:seq[int]):
  for i in N - 2:
    # A[i + 2] / A[i + 1] == A[i + 1] / A[i]
    if A[i + 1]^2 != A[i + 2] * A[i]:
      echo NO;return
  echo YES
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

