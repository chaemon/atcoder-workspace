when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const NO = "Impossible"
solveProc solve(N:int, A:seq[int], S:seq[string], Q:int, U:seq[int], V:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var S = newSeqWith(N, nextString())
  var Q = nextInt()
  var U = newSeqWith(Q, 0)
  var V = newSeqWith(Q, 0)
  for i in 0..<Q:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, A, S, Q, U, V)
else:
  discard

