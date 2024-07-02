when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var q = newSeq[int]()
  for i in N:
    q.add(A[i])
    while true:
      if q.len <= 1: break
      if q[^1] != q[^2]: break
      let
        d = q.pop()
        e = q.pop()
      doAssert d == e
      q.add(d + 1)
  echo q.len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

