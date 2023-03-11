const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, A:seq[int]):
  dp := Seq[N + 1: mint(0)]
  dp[0] = 1
  var
    min_v, max_v = Seq[tuple[A:int, s:mint]]
    min_s, max_s = mint(0)
  for i in N:
    block:
      s := mint(0)
      while min_v.len > 0:
        t := min_v.pop()
        if t.A < A[i]:
          min_v.add(t)
          break
        else:
          min_s -= t.A * t.s
          s += t.s
      s += dp[i]
      min_v.add((A[i], s))
      min_s += A[i] * s
    block:
      s := mint(0)
      while max_v.len > 0:
        t := max_v.pop()
        if t.A > A[i]:
          max_v.add(t)
          break
        else:
          max_s -= t.A * t.s
          s += t.s
      s += dp[i]
      max_v.add((A[i], s))
      max_s += A[i] * s
    dp[i + 1] = max_s - min_s
  echo dp[N]
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

