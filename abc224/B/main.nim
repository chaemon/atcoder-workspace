const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(H:int, W:int, A:seq[seq[int]]):
  for i1 in H:
    for i2 in i1+1..<H:
      for j1 in W:
        for j2 in j1+1..<W:
          if not (A[i1][j1] + A[i2][j2] <= A[i2][j1] + A[i1][j2]): echo NO;return
  echo YES
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, A)
else:
  discard

