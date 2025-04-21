when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var X, Y = 0
  for i in N - 1:
    if A[i] < A[i + 1]:
      X += A[i + 1] - A[i]
    else:
      Y += A[i] - A[i + 1]
  echo X, " ", Y

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

