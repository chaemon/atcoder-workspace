const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string, a:int, b:int):
  var S = S
  swap(S[a], S[b])
  echo S
  discard

when not DO_TEST:
  var S = nextString()
  var a = nextInt() - 1
  var b = nextInt() - 1
  solve(S, a, b)
else:
  discard

