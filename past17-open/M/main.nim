when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(P:seq[int], Q:seq[int], R:seq[int], S:seq[int], U:seq[int], V:seq[int]):
  ok := true
  proc calc(U, P, R:seq[int]):tuple[l, r:float] =
    var t0, t1:float
    # 区間[U[0] * t + P[0], U[0] * t + R[0]]と[U[1] * t + P[1], U[1] * t + R[1]]の時刻
    if U[0] != U[1]:
      t0 = (R[0] - P[1]) / (U[1] - U[0])
      t1 = (P[0] - R[1]) / (U[1] - U[0])
      if t0 > t1: swap t0, t1
    else:
      # 時刻t = 0を考えればよい
      # [P[0], R[0]], [P[1], R[1]]
      if max(P[0], P[1]) >= min(R[0], R[1]):
        ok = false
      else:
        t0 = -float.inf
        t1 = float.inf
    return (t0, t1)
  var (t0, t1) = calc(U, P, R)
  if not ok: echo 0;return
  var (s0, s1) = calc(V, Q, S)
  if not ok: echo 0;return
  t0.max=s0
  t1.min=s1
  t0.max=0.0
  if t0 > t1 or t1 < 0.0:
    echo 0;return
  else:
    t0.max=0.0
    echo t1 - t0
  discard

when not defined(DO_TEST):
  var P = newSeqWith(2, 0)
  var Q = newSeqWith(2, 0)
  var R = newSeqWith(2, 0)
  var S = newSeqWith(2, 0)
  var U = newSeqWith(2, 0)
  var V = newSeqWith(2, 0)
  for i in 0..<2:
    P[i] = nextInt()
    Q[i] = nextInt()
    R[i] = nextInt()
    S[i] = nextInt()
    U[i] = nextInt()
    V[i] = nextInt()
  solve(P, Q, R, S, U, V)
else:
  discard

