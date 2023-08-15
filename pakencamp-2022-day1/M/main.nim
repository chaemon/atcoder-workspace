when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const NO = "IMPOSSIBLE"
solveProc solve(N:int, P:seq[int], K:int, M:seq[int], S:seq[int], A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N-2+1, nextInt())
  var K = nextInt()
  var M = newSeqWith(K, 0)
  var S = newSeqWith(K, 0)
  for i in 0..<K:
    M[i] = nextInt()
    S[i] = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, P, K, M, S, A)
else:
  discard

