when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var ans:seq[(int, int, int)]
  for x in 0 .. N:
    for y in 0 .. N:
      for z in 0 .. N:
        if x + y + z <= N:
          echo x, " ", y, " ", z
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

