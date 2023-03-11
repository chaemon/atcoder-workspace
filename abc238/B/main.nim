const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var a = Seq[360:false]
  a[0] = true
  for i in N:
    a = a[360 - A[i] ..< 360] & a[0 ..< 360 - A[i]]
    assert not a[0]
    a[0] = true
  var b = Seq[int]
  for i in 0 ..< 360:
    if a[i]: b.add i
  var ans = 0
  for i in b.len - 1:
    ans.max= b[i + 1] - b[i]
  ans.max= b[0] + 360 - b[^1]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

