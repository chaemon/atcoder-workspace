const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  var a = initTable[string, int]()
  for s in S: a[s].inc
  var t = 0
  for k,v in a:
    t.max=v
  for k,v in a:
    if v == t:
      echo k;return
  return

when not DO_TEST:
  let N = nextInt()
  let S = Seq[N:nextString()]
  solve(N, S)
else:
  discard

