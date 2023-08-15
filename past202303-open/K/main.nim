when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, t:int, p:int, a:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var t = nextInt()
  var p = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, t, p, a)
else:
  discard

