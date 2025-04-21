when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var
    i = 0
    ans = 0
  while i < S.len:
    if S[i] == '0':
      var j = i
      while j < S.len and S[j] == '0': j.inc
      ans += (j - i + 1) div 2
      i = j
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

