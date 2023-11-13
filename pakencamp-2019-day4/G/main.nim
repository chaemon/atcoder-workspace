when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(n:int, a:int, m:int, p:int, t:int, K:int, s:string):
  discard

when not defined(DO_TEST):
  var n = nextInt()
  var a = nextInt()
  var m = nextInt()
  var p = nextInt()
  var t = nextInt()
  var K = nextInt()
  var s = nextString()
  solve(n, a, m, p, t, K, s)
else:
  discard

