when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(S:string):
  var
    i = 0
    ans = 0
  while i < S.len:
    if i + 1 < S.len and S[i] == '0' and S[i + 1] == '0':
      ans.inc
      i += 2
    else:
      ans.inc
      i.inc
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

