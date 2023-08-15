when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, a:seq[seq[int]], Q:int, s:seq[int], t:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, newSeqWith(N, nextInt()))
  var Q = nextInt()
  var s = newSeqWith(Q, 0)
  var t = newSeqWith(Q, 0)
  for i in 0..<Q:
    s[i] = nextInt()
    t[i] = nextInt()
  solve(N, K, a, Q, s, t)
else:
  discard

