const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

proc `$`(a:int):string =
  static:
    echo "nya"
  if a == int.inf: "inf"
  else: system.`$`(a)

echo $(int.inf)

solveProc solve(N:int, K:int, A:seq[int]):
  var dp = Seq[2^K: int.inf]
  dp[0] = 0
  for i in N:
    var dp2 = Seq[2^K: int.inf]
    for b in 2^K:
      let t = b.popCount
      if not b[A[i]]:
        # go left
        dp2[b].min= dp[b] + t
        # use
        # bの中でA[i]より大きいもの
        let s = (b and (((1 shl (K - 1 - A[i])) - 1) shl (A[i] + 1))).popCount
        #block:
        #  var s2 = 0
        #  for j in K:
        #    if A[i] < j and b[j]: s2.inc
        #  doAssert s == s2
        dp2[b xor (1 shl A[i])].min= dp[b] + s
      else:
        # go right
        dp2[b].min= dp[b] + K - t
      discard
    mixin `$`
    echo dp
    swap dp, dp2
  echo dp[(1 shl K) - 1]
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt() - 1)
  solve(N, K, A)
else:
  discard

