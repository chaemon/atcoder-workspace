when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N: int, A, B: seq[int]):
  ans := 0.0
  for i in N:
    ans += A[i] / 3 + B[i] * 2 / 3
  echo ans
  discard

when not defined(DO_TEST):
  let N = nextInt()
  var A, B = Seq[N: nextInt()]
  solve(N, A, B)
else:
  discard

