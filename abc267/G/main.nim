const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, K:int, A:seq[int]):
  var
    A = A.sorted(SortOrder.Descending)
    dp = Seq[K + 1: mint(0)]
    prev = int.inf
    ct = 0
  dp[0] = 1
  for i in N:
    if prev > A[i]:
      ct = 0
      prev = A[i]
    # A[i]に等しいものはct個ある
    dp2 := Seq[K + 1: mint(0)]
    for k in 0 .. K:
      # 挿入可能位置は
      # 増加部分がk個, 非増加がi - k個, 右端1個
      # 増加部分に挿入→個数に変化なし
      # 非増加部分に挿入
      #   prevの左ならば変化なし
      #   その他は1つ増える
      dp2[k] += dp[k] * (k + ct + 1) # 増加部分 or prevの左
      if k + 1 <= K and i + 1 - k - ct >= 0:
        dp2[k + 1] += dp[k] * (i - k - ct)
    dp = dp2.move
    ct.inc
  echo dp[K]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

