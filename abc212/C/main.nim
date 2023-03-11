const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var ans = int.inf
  for i in 0..<N:
    let j = B.lowerBound(A[i])
    if j < M:
      ans.min=abs(A[i] - B[j])
    if j - 1 >= 0:
      ans.min=abs(A[i] - B[j - 1])
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt()).sorted
  solve(N, M, A, B)
#}}}

