when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/extra/dp/cumulative_sum

solveProc solve(N:int, L:int, D:int):
  var
    cs1 = initCumulativeSumReverse[float](N + 1) # cs1[i]: iにいるときの勝てる確率
    cs2 = initCumulativeSum[float](L + D) # cs2[i]: ディーラーがiに滞在する確率
  let p = 1 / D
  cs2[0] = 1.0
  # もらうDPをやる
  for i in 1 ..< L + D:
    let
      l = max(i - D, 0)
      r = min(i, L)
    cs2[i] = cs2[l ..< r] * p
  let base = cs2[N + 1 .. ^1] # 相手がNより大きくなる確率
  for i in 0 .. N << 1:
    # そのまま終わる: 
    # ディーラーがNより大きかったら無条件に勝てる
    var ans = base
    if i >= L: # ディーラーがi未満なら勝てる
      ans += cs2[L ..< i]
    # サイコロをふる
    var
      l = i + 1
      r = min(N, i + D)
    ans.max= cs1[l .. r] * p
    cs1[i] = ans
  echo cs1[0 .. 0]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt()
  var D = nextInt()
  solve(N, L, D)
else:
  discard

