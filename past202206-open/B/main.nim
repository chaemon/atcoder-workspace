when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string):
  var ct = initTable[string, int]()
  for i in S.len - 1:
    var s = S[i .. i + 1]
    if s notin ct: ct[s] = 0
    ct[s].inc
  var
    m = -1
    vc:seq[string]
  for k, v in ct:
    m.max= v
  for k, v in ct:
    if v == m:
      vc.add k
  vc.sort
  echo vc[0]
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

