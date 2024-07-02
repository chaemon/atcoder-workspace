when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(X:int, Y:int, R:int, N:int):
  var ans = Seq[2 * N + 1, 2 * N + 1: '.']
  for i in -N .. N:
    for j in -N .. N:
      if (i - X)^2 + (j - Y)^2 <= R^2:
        ans[i + N][j + N] = '#'
  for i in ans.len:
    echo ans[i].join(" ")
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  var R = nextInt()
  var N = nextInt()
  solve(X, Y, R, N)
else:
  discard

