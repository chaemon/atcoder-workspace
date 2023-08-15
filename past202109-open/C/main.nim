when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, A:seq[int]):
  ans := 0
  for i in N:
    if A[i] == X:
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, A)
else:
  discard

