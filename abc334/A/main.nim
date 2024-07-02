when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(B:int, G:int):
  if B < G:
    echo "Glove"
  else:
    echo "Bat"
  discard

when not defined(DO_TEST):
  var B = nextInt()
  var G = nextInt()
  solve(B, G)
else:
  discard

