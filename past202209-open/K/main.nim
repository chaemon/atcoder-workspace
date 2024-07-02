when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
solveProc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, t:seq[int], x:seq[int], y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, M, a, b, Q, t, x, y)
else:
  discard

