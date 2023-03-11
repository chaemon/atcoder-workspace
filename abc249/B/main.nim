const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string):
  ok := true
  for i in S.len:
    for j in i + 1 ..< S.len:
      if S[i] == S[j]: ok = false
  block:
    found := false
    for i in S.len:
      if S[i] in 'a'..'z': found = true
    if not found: ok = false
  block:
    found := false
    for i in S.len:
      if S[i] in 'A'..'Z': found = true
    if not found: ok = false
  if ok: echo YES
  else: echo NO
  discard

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

