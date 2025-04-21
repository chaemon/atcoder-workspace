when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

import options

include lib/header/chaemon_header

solveProc solve(N:int, M:int, a:seq[int], b:seq[int]):
  Pred a, b
  var
    dir = [[0, 1], [1, 0], [1, -1], [1, 1]]
    cross = initSet[(int, int)]()
  # Ax = bを解く
  proc solve(A:seq[seq[int]], b:seq[int]): Option[seq[int]] =
    let d = A[0][0] * A[1][1] - A[0][1] * A[1][0]
    doAssert d != 0
    var A = A
    swap A[0][0], A[1][1]
    A[0][1] *= -1
    A[1][0] *= -1
    var x:seq[int]
    for i in 2:
      s := 0
      for j in 2:
        s += A[i][j] * b[j]
      x.add s
    for i in 2:
      if x[i] mod d != 0: return seq[int].none
      x[i].div=d
    return x.some
  var ds: array[4, tuple[x, y: int]] = [(0, 1), (1, 0), (1, 1), (1, -1)]
  var c = Array[4: initSet[int]()]
  for i in M:
    for d in 4:
      c[d].incl ds[d].x * a[i] + ds[d].y * b[i]
  var ans = 0
  ans += N * (c[0].len + c[1].len)
  for c in c[2]:
    # x + y = cの数
    # c = N - 1のときN個
    ans += N - abs(c - (N - 1))
  for c in c[3]:
    # x - y = cの数
    # 両辺N - 1を足して
    # y' = N - 1 - yで置き換えるとx + y' = c + N - 1
    ans += N - abs(c)
  # 交点を計算
  var intersections = initSet[(int, int)]()
  for i in 4:
    for j in i + 1 ..< 4:
      var A = Seq[2, 2:int]
      A[0][0] = ds[i].x
      A[0][1] = ds[i].y
      A[1][0] = ds[j].x
      A[1][1] = ds[j].y
      var b = Seq[2: int]
      for ci in c[i]:
        b[0] = ci
        for cj in c[j]:
          b[1] = cj
          var p = solve(A, b)
          if p.isNone: continue
          let x = p.get
          if x[0] notin 0 ..< N or x[1] notin 0 ..< N: continue
          intersections.incl (x[0], x[1])
  for (x, y) in intersections:
    var dup = 0
    for i,(dx, dy) in ds:
      let k = x * dx + y * dy
      if k in c[i]:
        dup.inc
    ans -= dup - 1
  echo N^2 - ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, M, a, b)
else:
  discard

