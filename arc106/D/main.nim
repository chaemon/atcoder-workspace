include atcoder/extra/header/chaemon_header
import atcoder/modint
import atcoder/convolution
import atcoder/extra/math/combination

const MOD = 998244353

type mint = modint998244353

proc solve(N:int, K:int, A:seq[int]) =
  var
    p = newSeqWith(N, mint(1))
    a = newSeq[mint](K + 1)
  for i in 0..K:
    a[i] = p.sum
    for j in 0..<N:
      p[j] *= A[j]
  # a[i] = A[0]^i + A[1]^i + A[2]^i + ...
  let i2 = mint(2).inv
  for X in 1..K:
    var ans = mint(0)
    for k in 0..X:
      ans += mint.C(X, k) * (a[k] * a[X - k] - a[X]) * i2
    echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
#}}}
