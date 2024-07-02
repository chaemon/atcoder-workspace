when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

const YES = "Yes"
const NO = "No"
solveProc solve(N:int):
  var d = 0
  block:
    var
      N = N
    while N > 0: d.inc;N.div=2
  for i in d:
    if N[i] != N[d - 1 - i]:
      echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

