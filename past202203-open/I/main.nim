when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, x:seq[int], y:seq[int], X:seq[int], Y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, x, y, X, Y)
else:
  discard

