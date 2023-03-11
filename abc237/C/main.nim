const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string):
  if S.count('a') == S.len:
    echo YES;return
  l := 0
  r := S.len - 1
  while S[l] == 'a': l.inc
  while S[r] == 'a': r.dec
  if l > S.len - 1 - r: echo NO;return
  while l < r:
    if S[l] != S[r]:
      echo NO;return
    l.inc;r.dec
  echo YES

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

