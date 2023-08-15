when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:int, A:int, B:int, C:int):
  let
    u = X / A + float(C)
    k = X / B
  if abs(u - k) < 1e-8:
    echo "Tie"
  elif u < k:
    echo "Hare"
  else:
    echo "Tortoise"
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(X, A, B, C)
else:
  discard

