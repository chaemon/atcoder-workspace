const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(X:int, Y:int, A:int, B:int, C:int):
  var (X, Y) = (X, Y)
  for _ in 2:
    if ceilDiv(A, X) + ceilDiv(B, X) + ceilDiv(C, X) <= Y: echo YES;return
    var (A, B, C) = (A, B, C)
    for _ in 3:
      var Y = Y - ceilDiv(A, X)
      if Y > 0:
        if B /^ Y + C /^ Y <= X: echo YES;return
      swap A, B
      swap B, C
    swap X, Y
  echo NO
  return

when not DO_TEST:
  var X = nextInt()
  var Y = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(X, Y, A, B, C)
else:
  discard

