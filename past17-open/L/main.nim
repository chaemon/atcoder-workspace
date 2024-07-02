when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve():
  var
    N = nextInt()
    a, b = Seq[N, N: int.inf]
  for i in N:
    for j in i + 1 ..< N:
      let d = nextInt()
      a[i][j] = d
      a[j][i] = d
  for i in N:
    for j in i + 1 ..< N:
      let d = nextInt()
      b[i][j] = d
      b[j][i] = d
  var
    d = Seq[N, N: array[2, int]]
  for i in N:
    for j in N:
      d[i][j] = [a[i][j], b[i][j]]
  for k in N:
    for i in N:
      for j in N:
        block:
          let d2 = d[i][k][0] + d[k][j][0]
          if d[i][j][0] > d2: d[i][j][0] = d2
        block:
          let d2 = d[i][k][1] + d[k][j][0]
          if d[i][j][1] > d2: d[i][j][1] = d2
        block:
          let d2 = d[i][k][0] + d[k][j][1]
          if d[i][j][1] > d2: d[i][j][1] = d2
  for i in N - 1:
    for j in i + 1 ..< N:
      stdout.write min(d[i][j][0], d[i][j][1])
      if j < N - 1: stdout.write " "
    echo ""
  doAssert false
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

