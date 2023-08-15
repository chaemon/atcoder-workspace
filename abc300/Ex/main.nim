when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/math/ntt
import lib/math/formal_power_series
import lib/math/formal_power_series_rational

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(K:int, N:int):
  var
    a:seq[mint]
    Q:FPS[mint]
    x = initVar[mint]()
  for i in K: a.add 1
  Q.add 1
  for i in K: Q.add -1
  var f = kitamasa(a, Q)
  var N = N
  while N > 0:
    #debug N, f.num.len, f.den.len
    if N mod 2 == 1:
      # (1 + x)をかけて定数項を引いてxで割る
      let f0 = f(0)
      var P = f.num * (1 + x) - f0 * f.den
      P = P shr 1
      f = P // f.den
    #var
    #  s:seq[mint]
    #  p = 0
    #for i in f.den.len * 2 + 10:
    #  s.add f[p]
    #  p += 2
    #f = s.getGeneratingFunction()
    var
      P, Q:array[2, FPS[mint]]
    for i in f.num.len:
      P[i mod 2].add f.num[i]
    for i in f.den.len:
      Q[i mod 2].add f.den[i]
    f =  (P[0] * Q[0] - P[1] * Q[1] * x) // (Q[0] * Q[0] - Q[1] * Q[1] * x)
    N = N div 2
  echo f(0)
  discard

when not defined(DO_TEST):
  var K = nextInt()
  var N = nextInt()
  solve(K, N)
else:
  discard

