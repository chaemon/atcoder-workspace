when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, M:int, R:seq[int], B:seq[int]):
  Pred R, B
  var rc, bc = Seq[N: 0]
  for i in M:
    rc[R[i]].inc
    bc[B[i]].inc
  var ct = Seq[2^N: tuple[r, b:int]]
  for b in 2^N:
    var rs, bs = 0
    for i in N:
      if b[i] == 1:
        rs += rc[i]
        bs += bc[i]
    ct[b] = (rs, bs)
  var
    dp = Seq[2^N: mint(0)]
    ans = mint(0)
  for b in 1 ..< 2^N:
    if ct[b].r != ct[b].b: continue
    var
      v = @b
      v2 = v[1 .. ^1]
      s = mint.fact(ct[b].r)
    for b2 in v2.subsets():
      let b2 = b2 or [v[0]]
      if b == b2 or ct[b2].r != ct[b2].b: continue
      s -= dp[b2] * mint.fact(ct[b xor b2].r)
    dp[b] = s
    ans += s * mint.fact(M - ct[b].r)
  ans *= mint.invFact(M)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var R = newSeqWith(M, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, R, B)
else:
  discard

