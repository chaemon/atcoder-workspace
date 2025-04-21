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
  var a = Seq[N, N: 0]
  for i in N:
    for j in i + 1:
      a[i][j] = nextInt() - 1
      a[j][i] = a[i][j]
  var t = 0
  for i in N:
    t = a[t][i]
  echo t + 1
  discard

when not DO_TEST:
  solve()
else:
  discard

