include atcoder/extra/header/chaemon_header

import atcoder/extra/math/divisor

const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int]) =
  for i in 0..<N:
    if A[i] == B[i]:
      echo -1
    else:
      echo abs(A[i] - B[i])
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
#}}}

