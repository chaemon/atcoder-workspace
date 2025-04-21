when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, q:seq[int], r:seq[int], Q:int, t:seq[int], d:seq[int]):
  Pred t
  for i in Q:
    let t = t[i]
    # d[i]以上でq[t]で割ったあまりがr[t]である数を出す
    var u = (d[i] - r[t]).ceilDiv(q[t])
    echo u * q[t] + r[t]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var q = newSeqWith(N, 0)
  var r = newSeqWith(N, 0)
  for i in 0..<N:
    q[i] = nextInt()
    r[i] = nextInt()
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var d = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    d[i] = nextInt()
  solve(N, q, r, Q, t, d)
else:
  discard

