when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, S:string):
  i := 0
  ans := ""
  while i < N:
    if i + 1 < N and S[i] == 'n' and S[i + 1] == 'a':
      ans &= "nya"
      i += 2
    else:
      ans &= S[i]
      i += 1
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

