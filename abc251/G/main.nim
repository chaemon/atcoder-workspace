const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, x:seq[int], y:seq[int], M:int, u:seq[int], v:seq[int], Q:int, a:seq[int], b:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  var Q = nextInt()
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, x, y, M, u, v, Q, a, b)
else:
  discard

