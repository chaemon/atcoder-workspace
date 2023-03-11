const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, A:seq[int], B:seq[int]):
  var A = A
  var B = B
  A.sort
  B.sort
  var ans = 0
  for i in 0..<N:
    ans += abs(A[i] - B[i])
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
#}}}

