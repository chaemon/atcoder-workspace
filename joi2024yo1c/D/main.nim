when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(K:int, N:int, A:seq[int], M:int, B:seq[int]):
  ans := 0
  for p in N:
    for q in M:
      if A[p] + K == B[q]: ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var K = nextInt()
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var M = nextInt()
  var B = newSeqWith(M, nextInt())
  solve(K, N, A, M, B)
else:
  discard

