when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/dp/cumulative_sum_2d

solveProc solve():
  let N, Q = nextInt()
  var
    P = Seq[N: nextString()]
    cs = initCumulativeSum2D[int](N * 2, N * 2)
  for i in N:
    for j in N:
      if P[i][j] == 'B':
        cs.add(i    , j    , 1)
        cs.add(i + N, j    , 1)
        cs.add(i    , j + N, 1)
        cs.add(i + N, j + N, 1)
  cs.build
  for _ in Q:
    var
      A, B, C, D = nextInt()
      ans = 0
    C.inc;D.inc
    # A ..< C, B ..< Dの長方形の黒を数える
    let
      qA = A div N
      qB = B div N
      qC = C div N
      qD = D div N
      rA = A mod N
      rB = B mod N
      rC = C mod N
      rD = D mod N
      dX = qC - qA - 1
      dY = qD - qB - 1
    if qA == qC and qB == qD:
      ans += cs[rA ..< rC, rB ..< rD]
    elif qA == qC:
      ans += cs[rA ..< rC, rB ..< rD + N]
      ans += cs[rA ..< rC, 0 ..< N] * dY
    elif qB == qD:
      ans += cs[rA ..< rC + N, rB ..< rD]
      ans += cs[0 ..< N, rB ..< rD] * dX
    else:
      ans += cs[rA ..< rC + N, rB ..< rD + N]
      ans += cs[rA ..< rC + N, 0 ..< N] * dY
      ans += cs[0 ..< N, rB ..< rD + N] * dX
      ans += cs[0 ..< N, 0 ..< N] * dX * dY
    echo ans
  discard

when not DO_TEST:
  solve()
else:
  discard

