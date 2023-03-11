when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  var
    a = N div 16
    b = N mod 16
    ans = ""
  if a < 10:
    ans &= ('0' + a)
  else:
    ans &= ('A' + a - 10)
  if b < 10:
    ans &= ('0' + b)
  else:
    ans &= ('A' + b - 10)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

