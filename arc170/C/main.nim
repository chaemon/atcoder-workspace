when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, M:int, S:seq[int]):
  var dp = Seq[N + 1: mint(0)] # dp[i]は利用箇所がi個
  dp[0] = 1
  for i in N:
    var dp2 = Seq[N + 1: mint(0)]
    for j in 0 .. N:
      # 今j箇所使っている
      if j > M + 1: break
      # dp[i]から
      if S[i] == 0:
        # 既存のところに入れる
        dp2[j] += dp[j] * j
        # 新しいところに入れる。最小のところはだめ
        let l = M + 1 - j
        if l - 1 >= 0 and j + 1 <= N:
          dp2[j + 1] += dp[j] * (l - 1)
      elif S[i] == 1:
        # 特定の一箇所に追加
        let l = M + 1 - j
        if l - 1 >= 0 and j + 1 <= N:
          dp2[j + 1] += dp[j]
      else:
        doAssert false
    dp = dp2.move
  echo dp.sum
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextInt())
  solve(N, M, S)
else:
  discard

