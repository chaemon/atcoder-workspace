when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/dsu

solveProc solve(N:int, M:int, X:seq[int], Y:seq[int], A:seq[int], B:seq[int], Z:seq[int]):
  ans := int.inf
  # 空港: N, 港: N + 1
  block:
    var v = Seq[tuple[c, x, y:int]]
    for u in N:
      # 空港
      v.add (X[u], u, N)
      v.add (Y[u], u, N + 1)
    for i in M:
      v.add (Z[i], A[i], B[i])
    v.sort
    var
      d = initDSU(N + 2)
      s = 0
    for (c, x, y) in v:
      if d.same(x, y): continue
      s += c
      d.merge(x, y)
    if d.size(0) == N + 2:
      ans.min= s
  block:
    var v = Seq[tuple[c, x, y:int]]
    for u in N:
      # 空港
      v.add (X[u], u, N)
      #v.add (Y[u], u, N + 1)
    for i in M:
      v.add (Z[i], A[i], B[i])
    v.sort
    var
      d = initDSU(N + 2)
      s = 0
    for (c, x, y) in v:
      if d.same(x, y): continue
      s += c
      d.merge(x, y)
    if d.size(0) == N + 1:
      ans.min= s
  block:
    var v = Seq[tuple[c, x, y:int]]
    for u in N:
      # 空港
      #v.add (X[u], u, N)
      v.add (Y[u], u, N + 1)
    for i in M:
      v.add (Z[i], A[i], B[i])
    v.sort
    var
      d = initDSU(N + 2)
      s = 0
    for (c, x, y) in v:
      if d.same(x, y): continue
      s += c
      d.merge(x, y)
    if d.size(0) == N + 1:
      ans.min= s
  block:
    var v = Seq[tuple[c, x, y:int]]
    #for u in N:
    #  # 空港
    #  #v.add (X[u], u, N)
    #  #v.add (Y[u], u, N + 1)
    for i in M:
      v.add (Z[i], A[i], B[i])
    v.sort
    var
      d = initDSU(N + 2)
      s = 0
    for (c, x, y) in v:
      if d.same(x, y): continue
      s += c
      d.merge(x, y)
    if d.size(0) == N:
      ans.min= s
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(N, nextInt())
  var Y = newSeqWith(N, nextInt())
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var Z = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    Z[i] = nextInt()
  solve(N, M, X, Y, A.pred, B.pred, Z)
else:
  discard

