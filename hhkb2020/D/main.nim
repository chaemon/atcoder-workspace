include atcoder/extra/header/chaemon_header

import atcoder/modint

const MOD = 1000000007

type mint = modint1000000007

proc calc(N, A, B:int) =
  var (A, B) = (A, B)
  if A > B: swap(A, B)
  # A <= B
  var ans = mint(0)
# first
  if A > 1:
    let max_val = N - (B + 1) + 1
    let min_val = N - min(A + B - 1, N) + 1
    if min_val <= max_val:
      ans += mint(min_val + max_val) * (max_val - min_val + 1) / 2
    ans *= 2
  ans += mint(B - A + 1) * (N - B + 1)

# second
#  if N - A - B >= 0:
#    ans = mint(N - A - B + 2) * (N - A - B + 1) / 2
#    ans *= 2
#  ans = mint(N - A + 1) * (N - B + 1) - ans

  ans ^= 2
  ans = (mint(N - A + 1)^2 * mint(N - B + 1)^2) - ans
  echo ans


proc solve() =
  let T = nextInt()
  for _ in 0..<T:
    let N, A, B = nextInt()
    calc(N, A, B)
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
