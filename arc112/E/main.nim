include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/math/combination

const DEBUG = true

const B = 3030
#S := Array(B, B, mint)
var S = Array(B, B, mint)
#var S:array[B, array[B, mint]]

proc solve(n:int, m:int, a:seq[int]) =
  S[0][0] = 1
  for i in 1..<B:
    for j in 0..i:
      S[i][j] = S[i - 1][j] * 2 * j
      if j > 0: S[i][j] += S[i - 1][j - 1]
  var ans = mint(0)
  # i..j
  for i in 0..<n:
    for j in i..<n:
      if i < j and a[j - 1] >= a[j]: break
      var s = mint(1)
      a := i
      b := n - 1 - j
      s *= mint.C(a + b, a) * S[m][a + b]
      ans += s
  for i in 0..n:
    var s = mint(1)
    s *= mint.C(n, i) * S[m][n]
    ans += s
  echo ans
  return

# input part {{{
block:
  var n = nextInt()
  var m = nextInt()
  var a = newSeqWith(n, nextInt())
  solve(n, m, a)
#}}}

