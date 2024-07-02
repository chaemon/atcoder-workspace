when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 2
type mint = modint2
solveProc solve(N:int, X:seq[int], Y:seq[int], Q:int, G:seq[int], R_a:int, R_b:int):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  var Q = nextInt()
  var G = newSeqWith(0+1, nextInt())
  var R_a = nextInt()
  var R_b = nextInt()
  solve(N, X, Y, Q, G, R_a, R_b)
else:
  discard

