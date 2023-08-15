when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 10000
type mint = modint10000
solveProc solve(N:int, T:seq[string], A:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, "")
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextString()
    A[i] = nextInt()
  solve(N, T, A)
else:
  discard

