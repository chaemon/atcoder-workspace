when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, X:seq[int], Y:seq[int]):
  var b = Seq[N: 0]
  for i in N:
    b[i] = i
  for j in M:
    b[X[j]] = Y[j]
  for i in N:
    echo b[i] + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt() - 1
    Y[i] = nextInt() - 1
  solve(N, M, X, Y)
else:
  discard

