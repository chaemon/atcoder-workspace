include atcoder/extra/header/chaemon_header

const MOD = 1000000007

import atcoder/modint
import atcoder/extra/math/combination
import atcoder/extra/dp/dual_cumulative_sum

type mint = modint1000000007

proc solve(N:int, K:int, M:int, A:seq[int]) =
  var ans = mint(K)^(N - M) * (N - M + 1)
  var isColorful = false
  block ColorfulTest:
    if M < K:break
    var ct = newSeq[int](K)
    for i in 0..<K:
      ct[A[i]].inc
    for i in K..M:
      var found = true
      for j in 0..<K:
        if ct[j] != 1: found = false
      if found: isColorful = true;break ColorfulTest

      if i == M:break
      ct[A[i - K]].dec
      ct[A[i]].inc
  var allDifferent = true
  if isColorful:
    echo ans;return
  block:
    var st = initSet[int]()
    for i in 0..<M:
      if A[i] in st:
        allDifferent = false
        break
      st.incl A[i]
  var ansd = mint(0)
  if allDifferent:
    var dp = Seq(K, tuple[num, sum:mint])
    dp[1].num = mint(K)
    if A.len == 1:
      dp[1].sum = dp[1].num
    for i in 1..<N:
      var dp2 = Seq(K, tuple[num, sum:mint])
      var cs_num, cs_sum = initDualCumulativeSum[mint](K)
      for j in 1..<K:
        # insert different letter
        if j != K - 1:
          dp2[j + 1].num += dp[j].num * (K - j)
          dp2[j + 1].sum += dp[j].sum * (K - j)
          if j + 1 >= M:
            dp2[j + 1].sum += dp[j].num * (K - j)
        # insert same letter: add 1..j
        cs_num.add(1..j, dp[j].num)
        cs_sum.add(1..j, dp[j].sum)
        if j >= M:
          cs_sum.add(M..j, dp[j].num)
      for j in 1..<K:
        dp2[j].num += cs_num[j]
        dp2[j].sum += cs_sum[j]
      swap(dp, dp2)
      discard
    for i in 1..<K:ansd += dp[i].sum
    ansd /= (mint.fact(K) / mint.fact(K - M))
  else:
    proc calc_dp(A:seq[int]):seq[mint] =
      result = newSeq[mint](N)
      var dp = Seq(K, mint)
      var st = initSet[int]()
      for i in 0..<A.len:
        if A[i] in st:
          dp[i] = mint(1)
          break
        st.incl A[i]
      result[0] = dp.sum
      for i in 0..<result.len:
        var dp2 = Seq(K, mint)
        var cs = initDualCumulativeSum[mint](K)
        for j in 1..<K:
          if j != K - 1:
            dp2[j + 1] += dp[j] * (K - j)
          cs.add(1..j, dp[j])
        for j in 1..<K:
          dp2[j] += cs[j]
        swap(dp, dp2)
        result[i + 1] = dp.sum
    let dp0 = calc_dp(A)
    let dp1 = calc_dp(A.reversed)
    for l in 0..<N:
      let r = N - M - l
      if r < 0: break
      ansd += dp0[l] * dp1[r]
  ans -= ansd
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, nextInt() - 1)
  solve(N, K, M, A)
#}}}
