when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, p:seq[int], x:seq[int], y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var p = newSeqWith(N-2+1, nextInt())
  var x = newSeqWith(M, 0)
  var y = newSeqWith(M, 0)
  for i in 0..<M:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, M, p, x, y)
else:
  discard

