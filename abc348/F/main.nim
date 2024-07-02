when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/extra/other/bitset

solveProc solve(N:int, M:int, A:seq[seq[int]]):
  Pred A
  var v = Seq[N: initBitSet[1000]()]
  for i in N:
    kk
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, A)
else:
  discard

