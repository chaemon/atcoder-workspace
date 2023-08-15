when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:seq[string]):
  var ans = ""
  for i in 8:
    for j in 8:
      if S[i][j] == '*':
        ans.add 'a' + j
        ans.add '1' + 7 - i
  echo ans
  discard

when not defined(DO_TEST):
  var S = newSeqWith(8, nextString())
  solve(S)
else:
  discard

