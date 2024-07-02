when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var A = A
  for i in N:
    if A[i] != -1: A[i].dec
  var
    next = Seq[N: -1]
    start = -1

  for i in N:
    if A[i] == -1: start = i
    else:
      next[A[i]] = i
  var
    ans:seq[int]
    p = start
  while true:
    ans.add p
    p = next[p]
    if p == -1: break
  for i in N: ans[i].inc
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

