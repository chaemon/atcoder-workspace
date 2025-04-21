when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(A:seq[int]):
  Pred A
  var
    c = Seq[4: 0]
    ans = 0
  for a in A:
    c[a].inc
  for t in c:
    ans += t div 2
  echo ans
  discard

when not defined(DO_TEST):
  var A = newSeqWith(4, nextInt())
  solve(A)
else:
  discard

