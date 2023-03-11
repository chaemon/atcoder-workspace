const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string):
  var a = [3, 2, 4, 1, 3, 5, 0, 2, 4, 6]
  var ct = Seq[7: 0]
  for i in S.len:
    if S[i] == '1':
      ct[a[i]].inc
  if S[0] == '1':
    echo NO;return
  for i in ct.len:
    if ct[i] == 0: continue
    for j in i + 2 ..< ct.len:
      if ct[j] == 0: continue
      found := true
      for k in i + 1 ..< j:
        if ct[k] > 0: found = false
      if found: echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

