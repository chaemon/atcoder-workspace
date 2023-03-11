const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var A = Seq[N * 2, N * 2: 0]
  for i in 2 * N:
    for j in i + 1 ..< 2 * N:
      A[i][j] = nextInt()
      A[j][i] = A[i][j]
  a := Seq[N * 2: false]
  ans := 0
  proc f(i, t:int) =
    if i == N * 2:
      ans.max= t
    elif a[i]:
      f(i + 1, t)
    else:
      for j in i + 1 ..< N * 2:
        if not a[j]:
          a[i] = true;a[j] = true
          f(i + 1, t xor A[i][j])
          a[i] = false;a[j] = false
  f(0, 0)
  echo ans
  discard

when not DO_TEST:
  solve()
else:
  discard

