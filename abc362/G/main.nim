when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, Q:int, T:seq[string]):
  discard

when not defined(DO_TEST):
  var S = nextString()
  var Q = nextInt()
  var T = newSeqWith(Q, nextString())
  solve(S, Q, T)
else:
  discard

