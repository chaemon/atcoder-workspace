when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[string]):
  var
    A = A
    p:seq[(int, int)]
  for i in N:
    p.add (0, i)
  for i in N:
    p.add (i, N - 1)
  for i in 0 ..< N << 1:
    p.add (N - 1, i)
  for i in 0 ..< N << 1:
    p.add (i, 0)
  p = p.deduplicate()
  var s:string
  for (x, y) in p:
    s.add A[x][y]
  s = s[^1] & s[0 ..< ^1]
  for i, (x, y) in p:
    A[x][y] = s[i]
  for i in N:
    echo A[i]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextString())
  solve(N, A)
else:
  discard

