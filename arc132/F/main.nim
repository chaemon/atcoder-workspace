const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(k:int, n:int, m:int, a:seq[string], b:seq[string]):
  discard

when not DO_TEST:
  var k = nextInt()
  var n = nextInt()
  var m = nextInt()
  var a = newSeqWith(n, nextString())
  var b = newSeqWith(m, nextString())
  solve(k, n, m, a, b)
else:
  discard

