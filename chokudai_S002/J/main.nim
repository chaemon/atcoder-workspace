include atcoder/extra/header/chaemon_header

import atcoder/extra/math/divisor

const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int]) =
  var ans = 0
  for d in A[0].divisor & B[0].divisor:
    var valid = true
    for j in 0..<N:
      if A[j] mod d != 0 and B[j] mod d != 0: valid = false
    if not valid: continue
    ans.max=d
  echo ans
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
