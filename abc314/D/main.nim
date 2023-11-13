when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string, Q:int, t:seq[int], x:seq[int], c:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  var c = newSeqWith(Q, "")
  for i in 0..<Q:
    t[i] = nextInt()
    x[i] = nextInt()
    c[i] = nextString()
  solve(N, S, Q, t, x, c)
else:
  discard

