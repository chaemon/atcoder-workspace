const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, a:seq[int], b:seq[int], Q:int, x:seq[int], y:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(N, nextInt())
  var Q = nextInt()
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, a, b, Q, x, y)
else:
  discard

