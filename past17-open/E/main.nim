when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var ans = Seq[string]
  var i = 0
  while i < S.len:
    j := i
    while j < S.len and S[j] == S[i]: j.inc
    ans &= S[i] & " " & $(j - i)
    i = j
  echo ans.join(" ")
  doAssert false
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

