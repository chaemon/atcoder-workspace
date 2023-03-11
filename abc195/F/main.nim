include atcoder/extra/header/chaemon_header

const DEBUG = true

import atcoder/extra/math/eratosthenes
import atcoder/extra/other/bitutils

proc solve(A:int, B:int) =
  if A == B:
    echo 2
    return
  let es = initEratosthenes(B - A + 1)
  let prm = es.prime
  let T = 2^prm.len
  var dp = Seq(T, int)
  dp[0] = 1
  for n in A..B:
    var mask = 0
    for i in 0..<prm.len:
      if n mod prm[i] == 0:mask[i] = 1
    var dp2 = dp
    for b in T:
      if b and mask: continue
      dp2[b or mask] += dp[b]
    swap(dp, dp2)
  echo dp.sum
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

