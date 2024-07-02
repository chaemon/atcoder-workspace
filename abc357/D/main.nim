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
solveProc solve(N:int):
  d := 0
  while 10^d <= N: d.inc
  d.dec
  debug d
  doAssert 10^d <= N and N < 10^(d+1)
  let r = mint(10^(d + 1))
  proc calc(n:int):(mint, mint) = # (r^n, 1 + r + ... + r^(n - 1))
    if n == 0:
      return (mint(1), mint(0))
    let
      m = n div 2
      (a, b) = calc(m)
    result[0] = a * a
    result[1] = a * b + b
    if n mod 2 == 1:
      result[0] *= r
      result[1] *= r
      result[1] += 1
  let (a, b) = calc(N)
  echo mint(N) * b
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

