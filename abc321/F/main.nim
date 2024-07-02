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

const B = 5000

solveProc solve():
  let
    Q, K = nextInt()
  var a = Seq[B + 1: mint(0)]
  a[0] = 1
  for _ in Q:
    let
      s = nextString()
      x = nextInt()
    if s[0] == '+':
      # 1 + t^xをかける
      for i in x .. B << 1:
        a[i] += a[i - x]
    elif s[0] == '-':
      # 1 + t^xでわる
      for i in 0 .. B - x:
        a[i + x] -= a[i]
    echo a[K]
  discard

when not DO_TEST:
  solve()
else:
  discard

