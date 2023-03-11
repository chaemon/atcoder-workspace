when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, t:seq[int], k:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var k = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    k[i] = nextInt()
  solve(N, Q, t, k)
else:
  discard

