when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, K:int):
  K := K mod S.len
  echo S[K .. ^1] & S[0 ..< K]
  discard

when not defined(DO_TEST):
  var S = nextString()
  var K = nextInt()
  solve(S, K)
else:
  discard

