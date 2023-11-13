when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var
    A = A.sorted.reversed
    S = A.sum
    B = Seq[N: S div N]
    ans = 0
  for i in S mod N:
    B[i].inc
  for i in N:
    if B[i] < A[i]:
      ans += A[i] - B[i]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

