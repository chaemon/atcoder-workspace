when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/math

# Failed to predict input format
solveProc solve(N, M, R:int):
  if N - R < 0:
    echo 0; return
  ans := 0
  # qmax: q * M + R <= Nとなる最大のq
  let qmax = (N - R) div M
  for k in 0 .. 33:
    let t = 2^k
    # 2 t m + t <= q M + R < 2 t m + 2 t
    # mmax: qmax M + R < 2 t m + 2 tとなるmの最小値
    let p = qmax * M + R - 2 * t
    let mmax = p.floorDiv(2 * t) + 1
    if mmax < 0: continue
    # m = mmaxについて
    # 2 t m + t <= q M + Rとなるq0の最小値をとる
    let q0 = (2 * t * mmax + t - R).ceilDiv M
    if q0 <= qmax: ans += qmax - q0 + 1
    # m < mmaxについてfloorsum
    ans += floor_sum(mmax, M, 2 * t, 2 * t - R + M - 1)
    ans -= floor_sum(mmax, M, 2 * t, t - R + M - 1)
  echo ans
  Naive:
    ans := 0
    for n in 1 .. N:
      if n mod M != R: continue
      ans += n.popCount
    echo ans
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    let N, M, R = nextInt()
    solve(N, M, R)
else:
  test(10^9, 10^8 - 1, 3)
  #for N in 1..100:
  #  for M in 1 .. N:
  #    for R in 0 ..< M:
  #      debug N, M, R
  #      test(N, M, R)

