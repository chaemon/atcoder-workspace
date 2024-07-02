when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(S:string, T:string):
  var T = T
  for i in T:
    T = T.tolower
  # T[0]を探す
  var i = 0
  while i < S.len and S[i] != T[0]: i.inc
  if i == S.len: echo NO;return
  i.inc
  while i < S.len and S[i] != T[1]: i.inc
  if i == S.len: echo NO;return
  i.inc
  if T[2] == 'x': echo YES;return
  while i < S.len and S[i] != T[2]: i.inc
  if i == S.len: echo NO;return
  i.inc
  echo YES
  discard

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

