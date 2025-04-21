when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, s:seq[string], p:seq[int], q:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var s = newSeqWith(N, "")
  var p = newSeqWith(N, 0)
  for i in 0..<N:
    s[i] = nextString()
    p[i] = nextInt()
  var q = newSeqWith(Q, nextInt())
  solve(N, Q, s, p, q)
else:
  discard

