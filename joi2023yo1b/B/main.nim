when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A: int, B: int):
  if A < B: echo -1
  elif A > B: echo 1
  else: echo 0
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

