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

import lib/math/online_convolution

import atcoder/convolution

solveProc solve(N:int, A:seq[int]):
  var
    S = mint(0)
  var
    t = initRelaxedMultiplication[mint]()
    F = mint(1) # F(0)
    ans:seq[mint]
  for i in N:
    S += t.add(F, F)
    F = S * A[i]
    ans.add F
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

