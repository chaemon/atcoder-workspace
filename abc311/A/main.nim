when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  var s = initSet[char]()
  for i in N:
    s.incl(S[i])
    if 'A' in s and 'B' in s and 'C' in s:
      echo i + 1;return

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

