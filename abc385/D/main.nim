when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, S_x:int, S_y:int, X:seq[int], Y:seq[int], D:seq[string], C:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S_x = nextInt()
  var S_y = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  var D = newSeqWith(M, "")
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    D[i] = nextString()
    C[i] = nextInt()
  solve(N, M, S_x, S_y, X, Y, D, C)
else:
  discard

