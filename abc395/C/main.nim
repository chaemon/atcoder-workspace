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
    prev = Seq[10^6 + 1: -1]
    ans = int.inf
  for i in N:
    if prev[A[i]] != -1:
      ans.min=i - prev[A[i]] + 1
    prev[A[i]] = i
  if ans.isInf:
    echo -1
  else:
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

