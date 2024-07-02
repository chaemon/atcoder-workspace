when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, KA:seq[int], A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var KA = newSeqWith(1, nextInt())
  var A = newSeqWith(N-2+1, nextInt())
  solve(N, M, KA, A)
else:
  discard

