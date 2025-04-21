when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
type mint = modint998244353

solveProc solve():
  let
    N, K = nextInt()
    A = Seq[N: nextInt()]
  var
    s = 0 # 今までの和
    ms = mint(1) # 今までの場合の和の和
    cs = initTable[int, mint]() # 累積和, 場合の和
  cs[0] = 1
  for i in N:
    s += A[i]
    let a = ms - cs[s - K]
    if i == N - 1:
      echo a
    cs[s] += a
    ms += a
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

