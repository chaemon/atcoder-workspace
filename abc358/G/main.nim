when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, K:int, S_i:int, S_j:int, A:seq[seq[int]]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var K = nextInt()
  var S_i = nextInt()
  var S_j = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, K, S_i, S_j, A)
else:
  discard

