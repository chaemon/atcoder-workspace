when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, a:seq[seq[int]]):
  var a = a
  for i in a.len:
    for j in a[0].len:
      a[i][j].dec
  var u = [N, N] @ false
  for i in M:
    for j in N - 1:
      u[a[i][j]][a[i][j + 1]] = true
      u[a[i][j + 1]][a[i][j]] = true
  var ans = 0
  for i in N:
    for j in i + 1 ..< N:
      if not u[i][j]:
        ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, newSeqWith(N, nextInt()))
  solve(N, M, a)
else:
  discard

