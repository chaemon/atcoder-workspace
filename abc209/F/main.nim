const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

type P = tuple[v:int, c:mint]
proc default(P:typedesc[P]):P = (int.inf, mint(0))

proc `+`(x, y:P):P =
  if x.v < y.v: return x
  elif x.v > y.v: return y
  else:
    result = x
    result.c += y.c

solveProc solve(N:int, H:seq[int]):
  var dp:seq[P] = @[(H[0], mint(1))]
  for i in 1..<N:
    var dp2 = Seq[i + 1:P.default]
    var left, right = Seq[i + 1: P.default]
    for j in 0..<dp.len:
      block:
        # i - 1 -> i
        var p = dp[j]
        p.v += H[i] + H[i]
        left[j + 1] = p
      block:
        # i -> i - 1
        var p = dp[j]
        p.v += H[i - 1] + H[i]
        right[j] = p
    block:
      var v = P.default
      for j in 0..<dp2.len:
        v = v + left[j]
        dp2[j] = dp2[j] + v
    block:
      var v = P.default
      for j in 0..<dp2.len << 1:
        v = v + right[j]
        dp2[j] = dp2[j] + v
    swap dp, dp2
  var ans = P.default
  for i in 0..<dp.len:
    ans = ans + dp[i]
  echo ans.c
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var H = newSeqWith(N, nextInt())
  solve(N, H)
#}}}

