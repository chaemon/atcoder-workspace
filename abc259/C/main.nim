const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc runLength(S:string):seq[tuple[c:char, l:int]] =
  var i = 0
  while i < S.len:
    var j = i
    while j < S.len and S[j] == S[i]: j += 1
    result.add (S[i], j - i)
    i = j

solveProc solve(S:string, T:string):
  let
    s = runLength(S)
    t = runLength(T)
  if s.len != t.len:
    echo NO;return
  for i in s.len:
    if s[i].c != t[i].c: echo NO;return
    if s[i].l == 1:
      if t[i].l != 1: echo NO;return
    if s[i].l > t[i].l: echo NO;return
  echo YES
  discard

when not DO_TEST:
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard
