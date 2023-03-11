when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(S:int, A:int, B:int):
  var
    p = 250
    s = A
  while true:
    if s >= S: break
    s += B
    p += 100
  echo p
  discard

when not defined(DO_TEST):
  var S = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(S, A, B)
else:
  discard

