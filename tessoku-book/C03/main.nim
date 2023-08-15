when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(D:int, X:int, A:seq[int], Q:int, S:seq[int], T:seq[int]):
  discard

when not defined(DO_TEST):
  var D = nextInt()
  var X = nextInt()
  var A = newSeqWith(D-2+1, nextInt())
  var Q = nextInt()
  var S = newSeqWith(Q, 0)
  var T = newSeqWith(Q, 0)
  for i in 0..<Q:
    S[i] = nextInt()
    T[i] = nextInt()
  solve(D, X, A, Q, S, T)
else:
  discard

