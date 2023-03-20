when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(S:string):
  S := S
  for i in 0 ..< S.len >> 2:
    swap S[i], S[i + 1]
  echo S
  discard

when not defined(DO_TEST):
  let S = nextString()
  solve(S)
else:
  discard

