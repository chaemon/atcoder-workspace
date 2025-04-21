when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, Q:int, R:seq[int], C:seq[int]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var Q = nextInt()
  var R = newSeqWith(Q, 0)
  var C = newSeqWith(Q, 0)
  for i in 0..<Q:
    R[i] = nextInt()
    C[i] = nextInt()
  solve(H, W, Q, R, C)
else:
  discard

