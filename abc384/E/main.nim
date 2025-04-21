when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, X:int, P:int, Q:int, S:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var X = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var S = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, X, P, Q, S)
else:
  discard

