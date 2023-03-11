include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

#const DEBUG = true

proc solve2(N:int, M:int):mint =
  proc f(a:seq[int]):mint =
    if a.len == 0: return 0
    let m = a.min
    var ans = mint(1)
    var i = 0
    while i < a.len:
      while i < a.len and a[i] == m: i.inc
      if i == a.len: break
      var j = i
      while j < a.len and a[j] > m: j.inc
      ans += f(a[i..<j])
      i = j
    return ans
  s := mint(0)
  for b in 0..<M^N:
    var a = Seq(N, int)
    var b = b
    for i in 0..<N:
      a[i] = b mod M + 1
      b = b div M
    s += f(a)
    debug a, f(a)
  return s

proc solve(N:int, M:int):mint {.discardable.} =
  dp := Seq(N + 1, mint)
  dp[0] = 0
  for i in 1..N: dp[i] = 1
  for m in 2..M: # value: 1..m
    s := mint(0)
    ss := mint(0)
    s2 := mint(0)
    t := mint(1)
    u := mint(1)
    var dp2 = dp # no value 1
    for l in 0..N:
      debug s, s2, t, u
      dp2[l] += (l - 1) * s - ss
      dp2[l] += s2 * 2
      dp2[l] += t - u
      debug t - u
      if l - 1 >= 0:
        s *= m
        s += dp[l - 1]
        ss *= m
        ss += (l - 1) * dp[l - 1]
      s2 *= m
      s2 += dp[l]
      t *= m
      u *= m - 1
    swap(dp, dp2)

  echo dp[N]
  return dp[N]

proc test() =
  for M in 1..5:
    for N in 1..5:
      let u = solve(N, M)
      let v = solve2(N, M)
      debug N, M, u, v
      assert u == v

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
#}}}

