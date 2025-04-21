when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, H:seq[string], T:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var H = newSeqWith(Q, "")
  var T = newSeqWith(Q, 0)
  for i in 0..<Q:
    H[i] = nextString()
    T[i] = nextInt()
  solve(N, Q, H, T)
else:
  discard

