when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, S:seq[seq[int]], N:int, r:seq[int], c:seq[int]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, newSeqWith(W, nextInt()))
  var N = nextInt()
  var r = newSeqWith(N, 0)
  var c = newSeqWith(N, 0)
  for i in 0..<N:
    r[i] = nextInt()
    c[i] = nextInt()
  solve(H, W, S, N, r, c)
else:
  discard

