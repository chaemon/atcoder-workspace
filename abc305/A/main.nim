when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var
    dmin = int.inf
    ans = -1
  for t in 0 .. 100 >> 5:
    let d = abs(N - t)
    if d < dmin:
      dmin = d
      ans = t
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

