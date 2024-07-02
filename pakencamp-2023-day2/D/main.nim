when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(M:int, N:int, L:int, A:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var M = nextInt()
  var N = nextInt()
  var L = nextInt()
  var A = newSeqWith(M, newSeqWith(N, nextInt()))
  solve(M, N, L, A)
else:
  discard

