when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int], Q:int, A:seq[int], B:seq[int]):
  Pred A, B, P
  var pos = Seq[N: int]
  for i in N:
    pos[P[i]] = i
  for i in Q:
    if pos[A[i]] < pos[B[i]]:
      echo A[i] + 1
    else:
      echo B[i] + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, P, Q, A, B)
else:
  discard

