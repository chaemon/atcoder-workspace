const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/dp/cumulative_sum

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, A:seq[int]):
  var cs = initCumulativeSumReverse[mint](N)
  cs.add(N - 1, mint(0))
  for i in 0 .. N - 2 << 1:
    let S = cs[i + 1 .. i + A[i]]
    cs.add(i, (S + A[i] + 1) / A[i])
  echo cs[0..0]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, nextInt())
  solve(N, A)
else:
  discard

