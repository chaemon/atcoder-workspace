const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, X:int, Y:int, A:seq[int], B:seq[int]):
  var dp = Seq[2^N:int.∞]
  dp[0] = 0
  for i in N:
    var dp2 = Seq[2^N:int.∞]
    # A[i]について
    for b in 0..<2^N:
      if dp[b] == int.∞: continue
      var ct = 0
      for j in N:
        if b[j] == 1: ct.inc;continue
        # A[i]とB[j]をつなげる
        dp2[b or [j]].min=dp[b] + abs(A[i] - B[j]) * X + (i - ct) * Y
    swap dp, dp2
  echo dp[2^N - 1]
  return

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, X, Y, A, B)
else:
  discard

