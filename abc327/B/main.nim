when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(B:int):
  for A in 1 .. 15:
    if A^A == B:
      echo A;return
  echo -1
  discard

when not defined(DO_TEST):
  var B = nextInt()
  solve(B)
else:
  discard

