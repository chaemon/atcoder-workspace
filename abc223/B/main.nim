const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(S:string):
  var min, max = ""
  for i in 0..S.len:
    var T = S[i ..< S.len] & S[0 ..< i]
    if min == "" or T < min: min = T
    if max == "" or max < T: max = T
  echo min
  echo max
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

