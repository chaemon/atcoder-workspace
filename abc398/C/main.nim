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
    ct = initTable[int, int]()
    ans = -int.inf
    ans_i:int
  for i in N:
    ct[A[i]].inc
  for i in N:
    if ct[A[i]] == 1:
      if ans < A[i]:
        ans = A[i]
        ans_i = i
  if ans == -int.inf:
    echo -1
  else:
    echo ans_i + 1
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

