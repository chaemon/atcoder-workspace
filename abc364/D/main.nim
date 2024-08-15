when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, a:seq[int], b:seq[int], k:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(Q, 0)
  var k = newSeqWith(Q, 0)
  for i in 0..<Q:
    b[i] = nextInt()
    k[i] = nextInt()
  solve(N, Q, a, b, k)
else:
  discard

