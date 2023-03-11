when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int, S: seq[int]):
  var A = Seq[N: int]
  A[0] = S[0]
  for i in 1 ..< N:
    A[i] = S[i] - S[i - 1]
  echo A.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextInt())
  solve(N, S)
else:
  discard

