include atcoder/extra/header/chaemon_header

const MOD = 998244353
#import atcoder/modint
#useStaticModInt(mint, MOD)
import atcoder/extra/math/modint_montgomery
useMontgomery(mint, MOD)

var A:int
var B:int
var C:int
var D:int

# input part {{{
proc main()
block:
  A = nextInt()
  B = nextInt()
  C = nextInt()
  D = nextInt()
#}}}

proc main() =
  var dp = Seq(D + 1, mint)
  for i in 0..<B:
    dp[i] = mint(1)
  var p = mint(1)
  for i in B..D:
    dp[i] = p
    p *= A
  for i in 0..<C - A:
    let a = A + i + 1
    var dp2 = Seq(D + 1, mint(0))
    var S = mint(0)
    for b in 1..D:
      dp2[b] = b * dp[b]
      if b >= B + 1:
        dp2[b] += S
      if b >= B:
        S *= a
        S += b * dp[b]
    swap(dp, dp2)
  echo dp[^1]
  return

main()
