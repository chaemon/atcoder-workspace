when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007
solveProc solve(N:int, M:int, start:seq[int], end:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var start = newSeqWith(M, 0)
  var end = newSeqWith(M, 0)
  for i in 0..<M:
    start[i] = nextInt()
    end[i] = nextInt()
  solve(N, M, start, end)
else:
  discard

