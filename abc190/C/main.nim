include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils

proc solve(N:int, M:int, A:seq[int], B:seq[int], K:int, C:seq[int], D:seq[int]) =
  var ans0 = -int.inf
  for b in (1 << K):
    var a = Seq(N, false)
    for i in 0..<K:
      if b[i]:
        a[C[i]] = true
      else:
        a[D[i]] = true
    var ans = 0
    for i in 0..<M:
      if a[A[i]] and a[B[i]]: ans.inc
    ans0.max=ans
  echo ans0
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
  var K = nextInt()
  var C = newSeqWith(K, 0)
  var D = newSeqWith(K, 0)
  for i in 0..<K:
    C[i] = nextInt() - 1
    D[i] = nextInt() - 1
  solve(N, M, A, B, K, C, D)
#}}}
