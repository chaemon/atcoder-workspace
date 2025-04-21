when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  proc dist(x0, y0, x1, y1: int):float =
    let
      dx = x0 - x1
      dy = y0 - y1
    return sqrt(float(dx^2 + dy^2))
  var s = 0.0
  s += dist(0, 0, X[0], Y[0])
  for i in N - 1:
    s += dist(X[i], Y[i], X[i + 1], Y[i + 1])
  s += dist(X[N - 1], Y[N - 1], 0, 0)
  echo s

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
else:
  discard

