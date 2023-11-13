when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let N, M = nextInt()
  var
    C, P = N @ int
    S = N @ seq[int]
  for i in N:
    C[i] = nextInt()
    P[i] = nextInt()
    for _ in P[i]:
      S[i].add nextInt()
  var a = M @ Option[float]
  proc calc(n:int):float =
    if n >= M: return 0.0
    if a[n].isSome: return a[n].get
    else:
      var u = float.inf # かかる金額の最小値を計算
      for i in N:
        var
          s = float(C[i])
          p = 1.0 / float(P[i])
          zero = 0
        for j in P[i]:
          if S[i][j] == 0:
            zero.inc
          else:
            s += calc(n + S[i][j]) * p
        s *= P[i] / (P[i] - zero)
        u.min=s
      a[n] = u.some
    return a[n].get
  echo calc(0)
  discard

when not DO_TEST:
  solve()
else:
  discard

