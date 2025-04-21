when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, r:seq[int], c:seq[int]):
  Pred r, c
  var a = Seq[N, N: false]
  for i in N - 1:
    a[r[i]][c[i]] = true
    for (dx, dy) in [(1, 0), (0, 1), (-1, 0), (0, -1), (1, -1), (-1, 1), (1, 1), (-1, -1)]:
      var
        x = r[i]
        y = c[i]
      while true:
        x += dx
        y += dy
        if x notin 0 ..< N or y notin 0 ..< N: break
        a[x][y] = true
  for x in N:
    for y in N:
      if not a[x][y]:
        echo x + 1, " ", y + 1;return
  echo -1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var r = newSeqWith(N-1, 0)
  var c = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    r[i] = nextInt()
    c[i] = nextInt()
  solve(N, r, c)
else:
  discard

