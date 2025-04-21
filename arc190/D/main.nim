when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/modint
type mint = modint

import lib/math/matrix

solveProc solve(N:int, p:int, A:seq[seq[int]]):
  mint.setMod(p)
  type MT = DynamicMatrixType(mint)
  var ans = Seq[N, N: 0]
  if p == 2:
    for i in N:
      for j in N:
        ans[i][j] = N mod 2
  else:
    var
      K = 0
      B = MT.init(A)^p
    for i in N:
      for j in N:
        if A[i][j] == 0: K.inc
    for i in N:
      if A[i][i] == 0:
        for j in N:
          if i != j and A[i][j] != 0:
            B[i, j] += A[i][j]
          if i != j and A[j][i] != 0:
            B[j, i] += A[j][i]
    if p == 3:
      for i in N:
        for j in N:
          if i == j: continue
          # i, j -> j, i -> i, j
          if A[i][j] == 0 and A[j][i] != 0:
            B[i, j] += A[j][i]
    if K mod 2 == 1:
      B *= -1
    for i in N:
      for j in N:
        ans[i][j] = B[i, j].val
  for i in N:
    echo ans[i].join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, p, A)
else:
  discard

