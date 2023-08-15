when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:int, B:int, C:int, D:int):
  var (A, B, C, D) = (A, B, C, D)
  if B < 0: B *= -1;A *= -1
  if D < 0: D *= -1;C *= -1
  if A * D < B * C:
    echo "<"
  elif A * D > B * C:
    echo ">"
  else:
    echo "="
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(A, B, C, D)
else:
  discard

