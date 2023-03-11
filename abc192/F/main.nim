include atcoder/extra/header/chaemon_header


const DEBUG = false

proc solve(N:int, X:int, A:seq[int]) =
  var ans = int.inf
  for k in 1..N:
    var dp = Seq(k, k + 1, -int.inf) # rem, num
    dp[0][0] = 0
    for i in 0..<N:
      var dp2 = dp # rem, num
      for r in 0..<k:
        for n in 0..k - 1:
          if dp[r][n] == -int.inf: continue
          let r2 = (r + A[i]) mod k
          let n2 = n + 1
          let s2 = dp[r][n] + A[i]
          debug r2, n2, s2
          if s2 <= X:
            dp2[r2][n2].max=s2
      swap(dp, dp2)
    debug dp
    let r = X mod k
    if dp[r][k] == -int.inf: continue
    debug r, dp[r][k], X - dp[r][k]
    ans.min=(X - dp[r][k]) div k
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, A)
#}}}
