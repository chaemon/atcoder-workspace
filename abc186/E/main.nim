include atcoder/extra/header/chaemon_header
import atcoder/math

proc solve() =
  T := nextInt()
  for _ in T:
    var N, S, K = nextInt()
    var g = gcd(N - K, N)
    if S mod g != 0:
      echo -1
      continue
    else:
      N = N div g
      K = K div g
      S = S div g
    let m = invMod(N - K, N)
    assert m != 0
    echo (m * S) mod N
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
#
