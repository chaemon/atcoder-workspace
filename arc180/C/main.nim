when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const M = 1000

solveProc solve(N:int, A:seq[int]):
  var
    dp = Seq[N: array[-M..M, mint]] # 直前, 和
    ans = mint(1)
  for i in N:
    var found = Array[-10..10: false]
    for j in countdown(i - 1, -1):
      # j -> i
      # 直前がjで和が0のとき
      var t = if j == -1: mint(1) else: dp[j][0]
      for u in -10 .. 10:
        if u == 0 or not found[u]: continue
        # A[j'] = uとなるj'でj' -> j
        dp[i][u + A[i]] += t
        ans += t
      if j == -1: break
      # 直前がjで和が0でないとき
      for s in -M .. M:
        if s == 0 or dp[j][s] == 0: continue
        let s2 = s + A[i]
        if s2 notin -M .. M: continue
        dp[i][s2] += dp[j][s]
        ans += dp[j][s]
      found[A[j]] = true
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

