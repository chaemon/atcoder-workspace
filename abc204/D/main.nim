include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, T:seq[int]) =
  let S = (T.sum + 10) div 2
  var dp = Seq[S: false]
  dp[0] = true
  for i in 0..<N:
    var dp2 = dp
    for t in 0..<S:
      if not dp[t]: continue
      let t2 = t + T[i]
      if t2 >= S: continue
      dp2[t2] = true
    swap(dp, dp2)
  var ans = int.inf
  let s = T.sum
  for i in 0..<S:
    if dp[i]:
      ans.min=max((s - i), i)
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var T = newSeqWith(N, nextInt())
  solve(N, T)
#}}}

