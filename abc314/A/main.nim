when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  let p = "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679"
  echo p[0..N+1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

