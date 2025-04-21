when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/sqrt_int, lib/math/eratosthenes

solveProc solve():
  var es = initEratosthenes(10^6 + 10)
  var v:seq[int]
  for M in 2 .. 10^6:
    # Mを素因数分解して2個の素因数からなるか？
    if es.factor(M).len == 2:
      v.add M^2
  let Q = nextInt()
  for _ in Q:
    let A = nextInt()
    echo v[v.upperBound(A) - 1]
  doAssert false

when not defined(DO_TEST):
  solve()
else:
  discard

