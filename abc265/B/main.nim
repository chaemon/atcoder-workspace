const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, T:int, A:seq[int], X:seq[int], Y:seq[int]):
  var b = initTable[int, int]()
  for i in M:
    b[X[i]] = Y[i]
  var t = T
  for i in 0 .. N - 2:
    # i -> i + 1
    if i in b: t += b[i]
    if t <= A[i]:
      echo NO;return
    t -= A[i]
  echo YES
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var T = nextInt()
  var A = newSeqWith(N-1, nextInt())
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, T, A, X.pred, Y)
else:
  discard

