when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, a:int, b:int, c:int, A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = nextInt()
  var b = nextInt()
  var c = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, a, b, c, A)
else:
  discard

