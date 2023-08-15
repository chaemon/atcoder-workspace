when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, r:seq[int], c:seq[int], x:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var r = newSeqWith(N, 0)
  var c = newSeqWith(N, 0)
  var x = newSeqWith(N, 0)
  for i in 0..<N:
    r[i] = nextInt()
    c[i] = nextInt()
    x[i] = nextInt()
  solve(N, r, c, x)
else:
  discard

