when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string):
  let t = S.rfind('a')
  echo if t == -1: -1 else: t + 1
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

