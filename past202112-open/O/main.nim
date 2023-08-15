when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/convolution

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(N:int, B:seq[int], S:seq[int]):
  let S = 0 & S
  const T = 2^17
  var
    ans:mint = 0
    a = T @ mint(0)
    b = T @ mint(0)
  for i in N:
    a[B[i]].inc
    b[T - B[i]].inc
  var c = a.convolution b
  for d in 1 .. N:
    # a[i] - b[i] = d
    # a[i] + T - B[i]
    ans += c[d + T] * (N - d) * S[d]
  ans *= mint.fact(N - 2)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var B = newSeqWith(N, nextInt())
  var S = newSeqWith(N, nextInt())
  solve(N, B, S)
else:
  discard

