when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/formal_power_series

import atcoder/modint
type mint = modint998244353

import atcoder/convolution

solveProc solve(A:int, B:int, C:int, T:int):
  proc calc(a, b, c:int):FormalPowerSeries[mint] =
    assert a mod 2 == b mod 2 and b mod 2 == c mod 2
    # x + a, x + b, x + c動く場合
    # 左にl, 右にr
    # l + r = T
    # r - l = a
    # l = (T - a) / 2
    # Σ_x C(T, (T - a - x) / 2) * C(T, (T - b - x) / 2) * C(T, (T - c - x) / 2)
    # C(T, (T - a - x) / 2) = T! / ((T - a - x) / 2)! ((T + a + x) / 2)!
    # i = (T - a - x) / 2とおく
    discard
  discard

when not defined(DO_TEST):
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var T = nextInt()
  solve(A, B, C, T)
else:
  discard

