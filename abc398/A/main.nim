when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  let d = N div 2
  var s, t:string
  if N mod 2 == 0:
    s = '-'.repeat(d - 1)
    t = "=="
  else:
    s = '-'.repeat(d)
    t = "="
  echo s & t & s

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

