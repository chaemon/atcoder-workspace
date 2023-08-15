when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
solveProc solve(N:int, C:string, A:string):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var C = nextString()
  var A = nextString()
  solve(N, C, A)
else:
  discard

