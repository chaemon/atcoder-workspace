when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, P:int, Q:int, R:int, S:int, A:seq[int]):
  Pred P, Q, R, S
  B := A
  for i in P .. Q:
    swap B[i], B[i - P + R]
  echo B.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var R = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, P, Q, R, S, A)
else:
  discard

