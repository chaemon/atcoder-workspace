when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, L:int, K:int, S:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt()
  var K = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, L, K, S)
else:
  discard

