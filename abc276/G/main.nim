when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/math/combination

import atcoder/modint
type mint = modint998244353

solveProc solve(N:int, M:int):
  # 合計MのN+1個
  # 両端はx, y
  # 差分の余りが1がa個, 残りが余り2でN - 1 - a個
  ans := mint(0)
  for x in 0 .. 2:
    for y in 0 .. 2:
      for a in 0 .. N - 1:
        var
          b = N - 1 - a
          a2 = a
          b2 = b
        if x == 1: a2.inc
        elif x == 2: b2.inc
        if y == 1: a2.inc
        elif y == 2: b2.inc
        var d = M - (a2 * 1 + b2 * 2)
        if d < 0 or d mod 3 != 0: continue
        d.div=3
        # 合計dをN + 1個の配分
        # d個の○とN個の棒
        ans += mint.C(N - 1, a) * mint.C(N + d, N)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

