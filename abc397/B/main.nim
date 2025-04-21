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
    ans = 0
    now = 'i'
  for s in S:
    if now != s:
      ans.inc
      now = if now == 'i': 'o' else: 'i'
    doAssert now == s
    now = if now == 'i': 'o' else: 'i'
  if now == 'o':
    ans.inc
  echo ans

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

