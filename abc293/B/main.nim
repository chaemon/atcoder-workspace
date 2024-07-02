when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  Pred A
  ct := Seq[N: 0]
  for i in N:
    if ct[i] == 0:
      ct[A[i]].inc
  ans := Seq[int]
  for i in N:
    if ct[i] == 0: ans.add i + 1
  echo ans.len
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  N := nextInt()
  A := Seq[N: nextInt()]
  solve(N, A)
else:
  discard

