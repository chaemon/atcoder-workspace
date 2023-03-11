const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, A:int, B:int, C:int):
  var SA, SB, SC = Seq[mint]
  proc calc(v:var seq[mint], A:int) =
    # v[n] = nC0 + nC1 + ... + nCA
    v = newSeq[mint](N + 1)
    for n in 0 .. N:
      if n <= A: v[n] = mint(2)^n
      else:
        # v[n - 1] = (n - 1)C0 + (n - 1)C1 + ... + (n - 1)CA
        # v[n - 1] = (n - 1)C(-1) + (n - 1)C0 +...+(n - 1)C(A - 1)
        # nCr = (n - 1)C(r - 1) + (n - 1)Cr
        v[n] = v[n - 1] * 2 - mint.C(n - 1, A)
  calc(SA, A)
  calc(SB, B)
  calc(SC, C)
  ans := mint(0)
  for n in 0 .. N:
    p := mint.C(N, n) * SA[N - n] * SB[N - n] * SC[N - n]
    if n mod 2 == 0:
      ans += p
    else:
      ans -= p
  echo ans
  discard

when not DO_TEST:
  block:
    var N = nextInt()
    var A = nextInt()
    var B = nextInt()
    var C = nextInt()
    solve(N, A, B, C)
else:
  discard

