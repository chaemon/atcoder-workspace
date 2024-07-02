when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], S:seq[int], T:seq[int]):
  var A = A
  for i in N - 1:
    A[i + 1] += (A[i] div S[i]) * T[i]
  echo A[N - 1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var S = newSeqWith(N-1, 0)
  var T = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    S[i] = nextInt()
    T[i] = nextInt()
  solve(N, A, S, T)
else:
  discard

