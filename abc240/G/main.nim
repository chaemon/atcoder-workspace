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

solveProc solve(N:int, X:int, Y:int, Z:int):
  let
    X = X.abs
    Y = Y.abs
    Z = Z.abs
  var ans = mint(0)
  for k in 0..N:
    if (N - k) mod 2 != Z mod 2: continue
    # (z + 1 / z) ^ (N - k) のz^Zの係数
    # z^(s)(1/z)^(N - k - s)
    # Z = s - (N - k - s)
    var S = mint.C(N, k)
    let s = (Z + N - k) div 2
    S *= mint.C(N - k, s)
    # (x + y)^k(1 + 1/(xy))^kのx^Xy^Yの係数
    # l , k - l
    # - m, - m
    # X = l - m
    # Y = k - l - m 
    # k - 2 * l = Y - X
    var l = k - Y + X
    if l mod 2 != 0: continue
    l = l div 2
    if l notin 0 .. k: continue
    let m = l - X
    if m notin 0 .. k: continue
    S *= mint.C(k, l) * mint.C(k, m)
    ans += S
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var Z = nextInt()
  solve(N, X, Y, Z)
else:
  discard

