when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/geometry/geometry_template
import lib/geometry/polygon

solveProc solve(N:int, X:seq[int], Y:seq[int], Q:int, A:seq[int], B:seq[int]):
  var P = @(Point[float])
  for i in N:
    P.add initPoint[float](X[i], Y[i])
  for i in Q:
    let p = initPoint[float](A[i], B[i])
    let c = contains(P, p)
    if c == IN:
      echo "IN"
    elif c == OUT:
      echo "OUT"
    else:
      echo "ON"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, X, Y, Q, A, B)
else:
  discard

