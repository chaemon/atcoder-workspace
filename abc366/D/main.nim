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
  let
    N = nextInt()
  var
    a = Seq[N, N, N: 0]
    cs = Seq[N + 1, N + 1, N + 1: 0]
  for i in N:
    for j in N:
      for k in N:
        a[i][j][k] = nextInt()
  for i in N:
    for j in N:
      for k in N:
        discard
  discard

when not DO_TEST:
  solve()
else:
  discard

