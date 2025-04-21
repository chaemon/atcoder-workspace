when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(P:int, Q:int, A:int, B:int):
  if Q <= P:
    echo Q * A
  else:
    echo P * A + (Q - P) * B
  discard

when not defined(DO_TEST):
  var P = nextInt()
  var Q = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(P, Q, A, B)
else:
  discard

