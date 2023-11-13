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
solveProc solve(N:int, A:seq[int], B:seq[int]):
  var
    A = A.sorted
    B = B.sorted
  # A[0]の両側を決める
  if A[0] > B[0] or A[0] > B[1]:
    echo 0;return
  var dp = @[mint(1)] # dp[i]はi個の隙間をリザーブする
  for i in 1 ..< N:
    # A[i]の位置を決める
    var dp2 = Seq[i + 1: mint(0)]
    for n in 0 .. i - 1:
      # リザーブn個
      # すでに決まってる人数: i人
      # i + 1 + n人の後列Bが決まっている(小さい順に並べる)
      let j = i + 1 + n

      # すでに2 * n + 2人の後列の場所が決まっている
      # リザーブ箇所に入る
      if n > 0:
        # どっちもリザーブしない: Bは誰も決まらない
        dp2[n - 1] += dp[n] * n
        # 片側だけリザーブ
        if j < B.len and B[j] > A[i]:
          dp2[n] += dp[n] * 2 * n
        # 両側リザーブ
        if j + 1 < B.len and n + 1 < dp2.len and B[j] > A[i] and B[j + 1] > A[i]:
          dp2[n + 1] += dp[n] * n
      # 両端のどっちかに入る
      # リザーブしない
      if j < B.len and B[j] > A[i]:
        dp2[n] += dp[n] * 2
      # リザーブする
      if j + 1 < B.len and n + 1 < dp2.len and B[j] > A[i] and B[j + 1] > A[i]:
        dp2[n + 1] += dp[n] * 2
    dp = dp2.move
  echo dp[0]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N+1, nextInt())
  solve(N, A, B)
else:
  discard

