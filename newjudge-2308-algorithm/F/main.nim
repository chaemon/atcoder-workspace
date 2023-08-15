when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:int, T:int, M:int, u:seq[int], v:seq[int]):
  discard

when not defined(DO_TEST):
  var S = nextInt()
  var T = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(S, T, M, u, v)
else:
  discard

