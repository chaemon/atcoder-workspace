when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, X:int, A:seq[int]):
  let B = A[0 ..< K] & X & A[K .. ^1]
  echo B.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, X, A)
else:
  discard

