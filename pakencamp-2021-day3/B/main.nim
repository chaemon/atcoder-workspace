const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, X:int, Y:int, A:seq[int]):
  if A.sum != X + Y:
    echo NO;return
  var
    j = 0
    s = 0
  for i in N: # i ..< j
    while s < X:
      s += A[j]
      j.inc
      if j == N: j = 0
    if s == X:
      echo YES;return
    s -= A[i]
    discard
  echo NO;return

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, Y, A)
else:
  discard

