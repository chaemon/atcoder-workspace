when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, type:seq[int], x:seq[int], y:seq[int], size:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var type = newSeqWith(N, 0)
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  var size = newSeqWith(N, 0)
  for i in 0..<N:
    type[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
    size[i] = nextInt()
  solve(N, type, x, y, size)
else:
  discard

