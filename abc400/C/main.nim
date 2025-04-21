when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/sqrt_int

solveProc solve(N:int):
  var
    ans = 0
    N = N
  while true:
    N.div=2
    if N == 0: break
    let u = sqrt_int(N)
    ans += (u + 1) div 2
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

