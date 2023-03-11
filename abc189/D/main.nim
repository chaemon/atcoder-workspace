include atcoder/extra/header/chaemon_header

proc solve(N:int, S:seq[string]) =
  var dp = [1, 1]
  for i in 0..<N:
    var dp2 = [0, 0]
    if S[i] == "AND":
      # 0
      dp2[0] += dp[0] + dp[1]
      # 1
      dp2[0] += dp[0]
      dp2[1] += dp[1]
    else:
      # 0
      dp2[0] += dp[0]
      dp2[1] += dp[1]
      # 1
      dp2[1] += dp[0] + dp[1]
    swap(dp, dp2)
  echo dp[1]
  return

# input part {{{
block:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
#}}}
