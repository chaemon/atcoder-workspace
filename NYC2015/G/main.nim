when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:int, x:seq[int], y:seq[int], d:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  var d = newSeqWith(N, "")
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
    d[i] = nextString()
  solve(N, T, x, y, d)
else:
  discard

