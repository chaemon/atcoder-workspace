when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  if N <= 2014 or N == 2017: echo -1
  elif N <= 2016: echo N - 2014
  else: echo N - 2015
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

