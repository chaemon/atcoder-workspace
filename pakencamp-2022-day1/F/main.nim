when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, D:int, L:seq[int], A:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var D = nextInt()
  var L = newSeqWith(N, nextInt())
  var A = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, D, L, A)
else:
  discard

