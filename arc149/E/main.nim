when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(N:int, M:int, K:int, B:seq[int]):
  shadow K
  if N - M + 1 < K:
    # revise K
    discard
  proc calc(B:seq[int]):mint =
    doAssert B.len >= M
    var s = B.sorted
    # 上からM - 1個をとる
    var v = s[^(M - 1) .. ^1]
    # v[0]以上が上位
    # 下位を取り出し
    var lower = Seq[int]
    for b in B:
      if b < v[0]: lower.add b
    debug lower
    ans := mint(0)
    for i in 1 .. lower.len:
      # lowerから最初のi個とる
      # 残りM - i個をupperで埋める(M - 1個から選ぶ)
      # 後ろは下位lower.len - i個、上位i - 1個
      let d = mint.C(M - 1, M - i) * mint.fact(M) * mint.C(lower.len - i + i - 1, i - 1) * mint.fact(i - 1)
      debug i, d, mint.C(M - 1, M - i), mint.fact(M)
      ans += d
      if lower[i - 1] > lower[i]: break # ソート順でないとだめ
    return ans
  echo calc(B)
  discard

solve(6, 3, 5, @[1, 4, 2, 3, 5, 6])

#when not defined(DO_TEST):
#  var N = nextInt()
#  var M = nextInt()
#  var K = nextInt()
#  var B = newSeqWith(N, nextInt())
#  solve(N, M, K, B)
#else:
#  discard
#
