when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/string/run_length_compress

solveProc solve(N:int, K:int, S:string):
  ans := 0
  for (c, n) in runLengthEncode(S):
    if c == 'X': continue
    ans += n div K
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var S = nextString()
  solve(N, K, S)
else:
  discard

