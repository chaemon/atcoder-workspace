when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var ct = Seq[26: 0]
  for i in S.len:
    ct[S[i] - 'a'].inc
  ans := 0
  if max(ct) >= 2:
    ans.inc
  for i in 26:
    for j in i + 1 ..< 26:
      ans += ct[i] * ct[j]
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

