include atcoder/extra/header/chaemon_header

var S:string

# input part {{{
proc main()
block:
  S = nextString()
#}}}

import atcoder/extra/math/combination

import atcoder/modint
type mint = modint998244353

const B = 302

var dp, dp2, dp3 = Array(B, B, false) # index, num-zero, num-one

static:
  echo 0..<B is int

proc main() =
  var ans = mint(0)
  let n = S.len
  dp[0][0] = true
  for i in 0..n:
    dp3.fill(false)
    var zero, one = 0
    for j in i - 1..<n:
      if j >= 0:
        if S[j] == '0': one.inc
        else: zero.inc
    for a in 0..<B << 1:
      for b in 0..<B << 1:
        if not dp[a][b]: continue
        # calculation
        var p, q:mint
#        p = mint.C_large(a + zero - 1, zero - 1)
#        q = mint.C_large(b + one - 1, one - 1)
        if a == 0 and zero == 0:
          p = 1
        else:
          p = mint.C(a + zero - 1, zero - 1)
        if b == 0 and one == 0:
          q = 1
        else:
          q = mint.C(b + one - 1, one - 1)
        let d = p * q
        ans += d
#        debug i, a, b, d, zero, one
        dp2[a][b] = true
        # forward
        # take two
        if (S[i] == '0' or S[i + 1] == '0') and a + 1 < B: dp3[a + 1][b] = true
        if (S[i] == '1' or S[i + 1] == '1') and b + 1 < B: dp3[a][b + 1] = true
        # take one
        if S[i] == '0' and a + 1 < B and b - 1 >= 0: dp2[a + 1][b - 1] = true
        if S[i] == '1' and b + 1 < B and a - 1 >= 0: dp2[a - 1][b + 1] = true
        # discard
        if a - 1 >= 0: dp[a - 1][b] = true
        if b - 1 >= 0: dp[a][b - 1] = true
    swap(dp, dp2)
    swap(dp2, dp3)
  ans.dec
  echo ans
  return

main()
