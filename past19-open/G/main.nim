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
  let N = nextInt()
  var
    A = Seq[N, N: nextInt()]
    i0, j0:int
  for i in N:
    for j in N:
      if A[i][j] == 0:
        i0 = i
        j0 = j
      A[i][j].dec
  var ans = 0
  for i in N:
    for j in N:
      for k in N:
        if (i, j) == (i0, j0) or (j, k) == (i0, j0): continue
        let
          s = A[i][j]
          t = A[j][k]
        if (s, k) == (i0, j0) or (i, t) == (i0, j0): continue
        if A[s][k] != A[i][t]:
          echo 0;return
  proc test(d:int):bool =
    A[i0][j0] = d
    block:
      let
        i = i0
        j = j0
      for k in N:
        if A[A[i][j]][k] != A[i][A[j][k]]: return false
    block:
      let
        j = i0
        k = j0
      for i in N:
        if A[A[i][j]][k] != A[i][A[j][k]]: return false
    block:
      let k = j0
      for i in N:
        for j in N:
          if A[A[i][j]][k] != A[i][A[j][k]]: return false
    block:
      let i = i0
      for j in N:
        for k in N:
          if A[A[i][j]][k] != A[i][A[j][k]]: return false
    A[i0][j0] = -1
    return true
  for d in N:
    if test(d): ans.inc
  echo ans

when not DO_TEST:
  solve()
else:
  discard

