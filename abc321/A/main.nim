when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int):
  var
    N = N
    a:seq[int]
  while N > 0:
    a.add N mod 10
    N.div=10
  for i in a.len - 1:
    if a[i] >= a[i + 1]: echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

