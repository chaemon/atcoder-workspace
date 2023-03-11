include atcoder/extra/header/chaemon_header

import atcoder/extra/math/combination

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const DEBUG = true

proc solve(N:string, K:int) =
  a := Seq(N.len, int)
  for i,d in N:
    if d in '0'..'9':
      a[i] = d.ord - '0'.ord
    else:
      a[i] = 10 + d.ord - 'A'.ord
  var dp = Seq(17, 17, a.len + 1, mint(0))
  # k, t, i
  # ‚·‚Å‚Ék•¶ŽšŒ»‚ê‚Ä‚¢‚é
  # ÅI“I‚Ét•¶Žš‚É‚µ‚½‚¢
  for k in 0..16:
    dp[k][0][0] = 1
    for i in 1..a.len:
      for t in 0..16:
        # Šù‘¶
        dp[k][t][i] += dp[k][t][i - 1] * (k + t)
        if t == 0: continue
        # V‹K
        let u = 16 - k - (t - 1)
        if u > 0:
          dp[k][t][i] += dp[k][t - 1][i - 1] * u
  ans := mint(0)
  st := initSet[int]()
  for i in 0..<a.len:
    # ’Ç]
    var s = 0
    if i == 0: s = 1
    for d in s..<a[i]:
      var k = st.len
      if d notin st: k.inc
      if k > K: continue
      ans += dp[k][K - k][a.len - i - 1]
    # 0Žn‚Ü‚è
    if i > 0:
      for d in 1..<16:
        let k = 1
        if k > K: continue
        ans += dp[k][K - k][a.len - i - 1]
    st.incl a[i]

  if st.len == K: ans.inc
  echo ans
  return

# input part {{{
block:
  var N = nextString()
  var K = nextInt()
  solve(N, K)
#}}}

