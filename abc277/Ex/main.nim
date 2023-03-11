when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/twosat

solveProc solve(N: int, M: int, Q: int, A: seq[int], B: seq[int], L: seq[int],
    R: seq[int]):
  Pred A, B
  # -1 .. Mで考える
  var ts = initTwoSAT(N * (M + 2))
  proc id(i, j: int): int = # X[i] <= j
    i * (M + 2) + j + 1
  for i in Q:
    for t in -1 .. M:
      var u = L[i] - t - 1
      u.max = -1
      if u > M:
        ts.addClause(id(A[i], t), false, id(A[i], t), false)
      else:
        ts.addClause(id(A[i], t), false, id(B[i], u), false)
    for t in -1 .. M:
      var u = R[i] - t - 1
      # uがMを超えていたらMとしてよい
      u.min = M
      # uが負だったら。。。
      if u < 0:
        ts.addClause(id(A[i], t), true, id(A[i], t), true)
      else:
        ts.addClause(id(A[i], t), true, id(B[i], u), true)
  for i in N:
    for t in -1 ..< M:
      # id(i, t) => id(i, t + 1)
      ts.addClause(id(i, t + 1), true, id(i, t), false)
    ts.addClause(id(i, M), true, id(i, M), true)
    ts.addClause(id(i, -1), false, id(i, -1), false)
  if not ts.satisfiable():
    echo -1
  else:
    let ans = ts.answer
    var X = Seq[N: int]
    #block:
    #  for i in N:
    #    for t in -1 .. M:
    #      let k = id(i, t)
    #      debug i, t, k, ans[k]
    for i in N:
      for t in 0 .. M:
        let k = id(i, t)
    for i in N:
      for t in 0 .. M:
        if ans[id(i, t)]:
          X[i] = t; break
    echo X.join(" ")
  Check(strm):
    Pred A, B
    let X0 = strm.nextInt()
    if X0 == -1: return
    var X = X0 & Seq[N - 1: strm.nextInt()]
    for i in N:
      doAssert X[i] in 0 .. M
    for i in Q:
      doAssert X[A[i]] + X[B[i]] in L[i] .. R[i]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, M, Q, A, B, L, R)
else:
  import random
  #let
  #  N = 2
  #  M = 4
  #  Q = 2
  #  A = @[1, 1]
  #  B = @[2, 2]
  #  L = @[1, 2]
  #  R = @[1, 2]
  #debug N, M, Q, A, B, L, R
  #solve(N, M, Q, A, B, L, R)
  #solve(1, 1, 1, @[1], @[1], @[0], @[0])
  #test(1, 1, 1, @[1], @[1], @[0], @[0])
  #for N in 2 .. 3:
  #  for M in 3 .. 5:
  #    for L in 0 .. M * 2:
  #      for R in L .. M * 2:
  #        for A in 1 .. N:
  #          for B in 1 .. N:
  #            debug N, M, 1, A, B, L, R
  #            solve(N, M, 1, @[A], @[B], @[L], @[R])
  #            test(N, M, 1, @[A], @[B], @[L], @[R])
  for N in 1 .. 10:
    for M in 1 .. 10:
      for Q in 1 .. 10:
        var A, B, L, R: seq[int]
        for i in Q:
          A.add random.rand(1 .. N)
          B.add random.rand(1 .. N)
          var l, r = random.rand(0 .. M * 2)
          if l > r: swap l, r
          L.add l
          R.add r
        debug N, M, Q, A, B, L, R
        test(N, M, Q, A, B, L, R)
