when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, R:int, D:seq[int], A:seq[int]):
  var R = R
  for i in N:
    if D[i] == 1:
      if R in 1600 ..< 2800:
        R += A[i]
    elif D[i] == 2:
      if R in 1200 ..< 2400:
        R += A[i]
  echo R
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var R = nextInt()
  var D = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    D[i] = nextInt()
    A[i] = nextInt()
  solve(N, R, D, A)
else:
  discard

