const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:string):
  var T = "atcoder"
  var pos = initTable[char, int]()
  for i in T.len:
    pos[T[i]] = i
  ans := 0
  for i in S.len:
    for j in i + 1 ..< S.len:
      if pos[S[i]] > pos[S[j]]: ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

