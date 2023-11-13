when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, S:string, l:seq[int], r:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var S = nextString()
  var l = newSeqWith(Q, 0)
  var r = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt()
    r[i] = nextInt()
  solve(N, Q, S, l, r)
else:
  discard

