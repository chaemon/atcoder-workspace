const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  s := 0
  for i in N:
    s += abs(A[i] - B[i])
  if s > K: echo NO
  elif (K - s) mod 2 != 0: echo NO
  else: echo YES
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, K, A, B)
#}}}

