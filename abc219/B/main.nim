const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(S:seq[string], T:string):
  var ans = ""
  for t in T:
    if t == '1': ans.add S[0]
    elif t == '2': ans.add S[1]
    elif t == '3': ans.add S[2]
  echo ans
  return

when not DO_TEST:
  var S = newSeqWith(3, nextString())
  var T = nextString()
  solve(S, T)
else:
  discard

