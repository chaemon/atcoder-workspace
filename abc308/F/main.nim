when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, P:seq[int], L:seq[int], D:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = newSeqWith(N, nextInt())
  var L = newSeqWith(M, nextInt())
  var D = newSeqWith(M, nextInt())
  solve(N, M, P, L, D)
else:
  discard

