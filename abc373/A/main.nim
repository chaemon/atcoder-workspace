when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:seq[string]):
  ans := 0
  for i in S.len:
    if i + 1 == S[i].len:
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var S = newSeqWith(12, nextString())
  solve(S)
else:
  discard

