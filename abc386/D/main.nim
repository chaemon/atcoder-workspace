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
solveProc solve(N:int, M:int, X:seq[int], Y:seq[int], C:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  var C = newSeqWith(M, "")
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
    C[i] = nextString()
  solve(N, M, X, Y, C)
else:
  discard

