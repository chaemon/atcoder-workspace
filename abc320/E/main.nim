when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, T:seq[int], W:seq[int], S:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var T = newSeqWith(M, 0)
  var W = newSeqWith(M, 0)
  var S = newSeqWith(M, 0)
  for i in 0..<M:
    T[i] = nextInt()
    W[i] = nextInt()
    S[i] = nextInt()
  solve(N, M, T, W, S)
else:
  discard

