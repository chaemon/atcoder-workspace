when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination
import lib/dp/cumulative_sum

solveProc solve(N:int, A:seq[int]):
  var A = A
  for i in N:
    if A[i] != -1: A[i].dec
  var
    m = A.count(-1)
    s = 0 # 固定位置での転倒数全体
    ans = mint(0)
    cs_not_assigned_val, cs_not_assigned_pos = initCumulativeSum[int](N) # 未定の値の累積
  for i in N:
    if A[i] == -1: continue
    for j in i + 1 ..< N:
      if A[j] == -1 or A[i] < A[j]: continue
      s.inc
  block:
    var assigned = false.repeat(N)
    for i in N:
      if A[i] != -1:
        assigned[A[i]] = true
      else:
        cs_not_assigned_pos.add(i, 1)
    for i in N:
      if not assigned[i]: cs_not_assigned_val.add(i, 1)
  # i < j, P[i] > P[j], k < l, P[k] > P[l]となる(i, j, k, l)の組を数える
  # i, j, k, lのうちAの値が-1のものがいくつになるかで場合分け
  # 0個の場合
  block:
    # left[i] : iの左に転倒するものがいつくあるか？
    # right[i]: iの右に転倒するものがいくつあるか？
    d := mint(s) * mint(s)
    ans += d * mint.fact(m)
  # 1個の場合
  block:
    var d = mint(0)
    for i in N:
      if A[i] != -1: # 固定の右に未定
        # (固定, 未定)の数
        d += cs_not_assigned_val[0 ..< A[i]] * cs_not_assigned_pos[i + 1 ..< N]
        # (未定, 固定)の数
        d += cs_not_assigned_val[A[i] + 1 ..< N] * cs_not_assigned_pos[0 ..< i]
    if m - 1 >= 0:
      ans += d * mint.fact(m - 1)
  # 2個の場合
  block:
    # iとkが固定
    for x in N:
      if A[x] == -1: continue
      for y in N:
        if A[y] == -1: continue

    discard
  # 3個の場合
  block:
    discard
  # 4個の場合
  block:
    discard

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

