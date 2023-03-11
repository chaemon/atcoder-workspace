include atcoder/extra/header/chaemon_header

const DEBUG = true

import atcoder/extra/other/binary_search
import atcoder/extra/other/bitutils

proc solve(N:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int], E:seq[int]) =
  proc f(M:int):bool =
    var dp = Array[2^5, 4: false]
    dp[0][0] = true
    for i in 0..<N:
      var dp2 = dp
      for b in 2^5:
        for t in 0..2:
          if not dp[b][t]: continue
          var b2 = b
          if A[i] >= M: b2[0] = 1
          if B[i] >= M: b2[1] = 1
          if C[i] >= M: b2[2] = 1
          if D[i] >= M: b2[3] = 1
          if E[i] >= M: b2[4] = 1
          dp2[b2][t + 1] = true
      swap(dp, dp2)
    for i in 0..3:
      if dp[2^5 - 1][i]: return true
    return false
  echo f.maxRight(0..10^9 + 1)
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  var E = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
    E[i] = nextInt()
  solve(N, A, B, C, D, E)
#}}}

