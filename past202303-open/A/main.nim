when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:int, T:int):
  let N = N + T
  if N mod 2 == 0:
    if S == 0:
      echo "Bob"
    else:
      echo "Alice"
  else:
    if S == 0:
      echo "Alice"
    else:
      echo "Bob"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var T = nextInt()
  solve(N, S, T)
else:
  discard

