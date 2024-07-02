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
    A = sorted(A)
    q = 0
  for x in A:
    q += N - A.lowerBound(10^8 - x)
  var ans = A.sum * N * 2 - q * 10^8
  for x in A:
    ans -= (x + x) mod 10^8
  ans.div=2
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

