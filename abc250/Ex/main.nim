const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, K:int, a:seq[int], b:seq[int], c:seq[int], Q:int, x:seq[int], y:seq[int], t:seq[int]):
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
  var Q = nextInt()
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  var t = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    y[i] = nextInt()
    t[i] = nextInt()
  solve(N, M, K, a, b, c, Q, x, y, t)
else:
  discard

