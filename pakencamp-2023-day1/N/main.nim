when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(Q:int, H:seq[int], W:seq[int], K:seq[int]):
  discard

when not defined(DO_TEST):
  var Q = nextInt()
  var H = newSeqWith(Q, 0)
  var W = newSeqWith(Q, 0)
  var K = newSeqWith(Q, 0)
  for i in 0..<Q:
    H[i] = nextInt()
    W[i] = nextInt()
    K[i] = nextInt()
  solve(Q, H, W, K)
else:
  discard

