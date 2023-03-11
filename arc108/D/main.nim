include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

proc solve() =
  let N = nextInt()
  var
    AA = nextString()[0]
    AB = nextString()[0]
    BA = nextString()[0]
    BB = nextString()[0]
  if N == 2:
    echo 1;return
#  if AB == 'B':
#    # swap, A, B and reverse
#    AB = 'A'
  proc calc_non_consective():mint =
    var dp = Seq(2, mint)
    dp[0] = 1
    for i in 0..<N - 1:
      var dp2 = Seq(2, mint)
      dp2[0] += dp[0] + dp[1]
      dp2[1] += dp[0]
      swap(dp, dp2)
    return dp[1]

  if AB == 'A':
    if AA == 'A':
      echo 1;return
    else: # AA == 'B'
      if BA == 'B':
        echo mint(2)^(N - 3);return
      else:
        echo calc_non_consective();return
  else:
    if BB == 'B':
      echo 1;return
    else:
      if BA == 'A':
        echo mint(2)^(N - 3);return
      else:
        echo calc_non_consective();return
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
