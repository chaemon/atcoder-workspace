when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  ans := (N * (N - 1)) div 2
  if N mod 2 == 1:
    ans.dec
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

