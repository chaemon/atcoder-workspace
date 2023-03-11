when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(a:int, b:int, c:int, d:int):
  echo (a + b) * (c - d)
  echo "Takahashi"
  discard

when not defined(DO_TEST):
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  solve(a, b, c, d)
else:
  discard

