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
    tb0, tb1 = initTable[int, int]()
    ans = -int.inf
  for i in N:
    tb1[A[i]].inc
  for i in N - 1:
    # A[i]を除く
    tb0[A[i]].inc
    tb1[A[i]].dec
    if tb1[A[i]] == 0: tb1.del A[i]
    ans.max=tb0.len + tb1.len
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

