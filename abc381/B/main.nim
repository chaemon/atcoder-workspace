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
solveProc solve(S:string):
  if S.len mod 2 != 0: echo NO;return
  var
    i = 0
    ct = Seq[26: 0]
  while i < S.len:
    if S[i] != S[i + 1]: echo NO;return
    let c = S[i]
    ct[c - 'a'].inc
    if ct[c - 'a'] >= 2: echo NO;return
    i += 2
  echo YES

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

