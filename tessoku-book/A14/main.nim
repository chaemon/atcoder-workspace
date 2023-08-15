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
solveProc solve(N:int, K:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  var s = initSet[int]()
  for i in N:
    for j in N:
      s.incl A[i] + B[j]
  for i in N:
    for j in N:
      if K - C[i] - D[j] in s: echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  var D = newSeqWith(N, nextInt())
  solve(N, K, A, B, C, D)
else:
  discard

