when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  Pred A
  var pos = Seq[N: seq[int]]
  for i in A.len:
    pos[A[i]].add i
  var ans = 0
  for i in pos.len:
    if abs(pos[i][0] - pos[i][1]) == 2:
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(2*N, nextInt())
  solve(N, A)
else:
  discard

