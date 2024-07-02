when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:seq[int], W:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = newSeqWith(N, 0)
  var W = newSeqWith(N, 0)
  for i in 0..<N:
    H[i] = nextInt()
    W[i] = nextInt()
  solve(N, H, W)
else:
  discard

