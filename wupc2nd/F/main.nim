when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, L:int, S:string, c:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var L = nextInt()
  var S = nextString()
  var c = newSeqWith(N, nextString())
  solve(N, M, L, S, c)
else:
  discard

