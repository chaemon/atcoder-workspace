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
solveProc solve(N:int, A:seq[int], M:int, B:seq[int], L:int, C:seq[int], Q:int, X:seq[int]):
  var s = initSet[int]()
  for i in N:
    for j in M:
      for k in L:
        s.incl A[i] + B[j] + C[k]
  for X in X:
    if X in s:
      echo YES
    else:
      echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var M = nextInt()
  var B = newSeqWith(M, nextInt())
  var L = nextInt()
  var C = newSeqWith(L, nextInt())
  var Q = nextInt()
  var X = newSeqWith(Q, nextInt())
  solve(N, A, M, B, L, C, Q, X)
else:
  discard

