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

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, C:seq[int]):
  var
    d = initDeque[FPS[mint]]()
    x = initVar[mint]()
  for i in M:
    var p:FPS[mint] = 1 - x^C[i]
    d.addFirst p
  while d.len > 1:
    d.addLast d.popFirst * d.popFirst
  let p = d.popFirst
  var ans = mint(0)
  for k in 0 .. N - 1:
    ans += N / mint(N - k) * p[k]
  if (M - 1) mod 2 == 1: ans *= -1
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var C = newSeqWith(M, nextInt())
  solve(N, M, C)
else:
  discard

