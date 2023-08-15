when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var
    ct = initTable[int, int]()
    ans = 0
  for i in N:
    if A[i] notin ct: ct[A[i]] = 0
    ct[A[i]].inc
  for k, v in ct:
    ans += v div 2
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

