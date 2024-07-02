when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(b:seq[int], N:int, a:seq[int]):
  discard

when not defined(DO_TEST):
  var b = newSeqWith(9+1, nextInt())
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(b, N, a)
else:
  discard

