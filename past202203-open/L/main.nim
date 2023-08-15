when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(K:int, M:int, C:seq[int], D:seq[int]):
  discard

when not defined(DO_TEST):
  var K = nextInt()
  var M = nextInt()
  var C = newSeqWith(K, 0)
  var D = newSeqWith(K, 0)
  for i in 0..<K:
    C[i] = nextInt()
    D[i] = nextInt()
  solve(K, M, C, D)
else:
  discard

