const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[string]):
  for i in N:
    for j in N:
      if i == j: continue
      if A[i][j] == 'W':
        if A[j][i] != 'L':
          echo "incorrect";return
      elif A[i][j] == 'L':
        if A[j][i] != 'W':
          echo "incorrect";return
      elif A[i][j] == 'D':
        if A[j][i] != 'D':
          echo "incorrect";return
  echo "correct"
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextString())
  solve(N, A)
else:
  discard

