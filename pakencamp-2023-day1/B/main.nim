when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, a:int, b:int, c:int, d:int):
  var (a, b, c, d) = (a, b, c, d)
  if c > d: swap c, d
  if a in [c, d] or b in [c, d]:
    echo 3
  elif a in c .. d and b notin c .. d:
    echo 4
  elif b in c .. d and a notin c .. d:
    echo 4
  else:
    echo 3
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var d = nextInt()
  solve(N, a, b, c, d)
else:
  discard

