const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, A:seq[int], Q:int, B:seq[int]):
  var A = A
  A.sort
  for B in B:
    var i = A.lower_bound(B)
    var ans = int.inf
    if i < N: ans.min=abs(B - A[i])
    if i > 0: ans.min=abs(B - A[i - 1])
    echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var Q = nextInt()
  var B = newSeqWith(Q, nextInt())
  solve(N, A, Q, B)
#}}}

