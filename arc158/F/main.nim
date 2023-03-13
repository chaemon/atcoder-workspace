when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, K:int, A:seq[int], B:seq[int]):
  discard

when not defined(DO_TEST):
  
else:
  discard

