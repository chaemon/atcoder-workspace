when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, N:int, R:seq[int], C:seq[int]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var R = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    R[i] = nextInt()
    C[i] = nextInt()
  solve(H, W, N, R, C)
else:
  discard

