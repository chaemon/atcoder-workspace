when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, W:int, X:seq[int], Y:seq[int], Q:int, T:seq[int], A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var W = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  var Q = nextInt()
  var T = newSeqWith(Q, 0)
  var A = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    A[i] = nextInt()
  solve(N, W, X, Y, Q, T, A)
else:
  discard

