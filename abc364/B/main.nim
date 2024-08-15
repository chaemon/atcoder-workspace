when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, S_i:int, S_j:int, C:seq[string], X:string):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S_i = nextInt()
  var S_j = nextInt()
  var C = newSeqWith(H, nextString())
  var X = nextString()
  solve(H, W, S_i, S_j, C, X)
else:
  discard

