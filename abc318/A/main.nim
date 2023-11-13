when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, P:int):
  ans := 0
  for d in 1 .. N:
    let x = d - M
    if x < 0: continue
    if x mod P == 0:
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = nextInt()
  solve(N, M, P)
else:
  discard

