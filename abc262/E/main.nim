const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(N:int, M:int, K:int, U:seq[int], V:seq[int]):
  var deg = Seq[N: 0]
  for i in M:
    deg[U[i]].inc
    deg[V[i]].inc
  var
    odd = 0
    even = 0
  for u in N:
    if deg[u] mod 2 == 0: even.inc
    else: odd.inc
  # K個のうち奇数次を偶数個選ぶ
  var
    t = 0
    ans = mint(0)
  while t <= K:
    ans += mint.C(odd, t) * mint.C(even, K - t)
    t += 2
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt() - 1
    V[i] = nextInt() - 1
  solve(N, M, K, U, V)
else:
  discard

