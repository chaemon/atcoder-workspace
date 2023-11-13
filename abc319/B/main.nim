when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var s = '-'.repeat(N + 1)
  for i in 0 .. N:
    for j in 1 .. 9:
      if N mod j == 0:
        if i mod (N div j) == 0:
          s[i] = '0' + j
          break
  echo s
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

