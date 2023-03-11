const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string]):
  var pos = Seq[N, 10:int]
  for i in N:
    for j, s in S[i]:
      let d = s.ord - '0'.ord
      pos[i][d] = j
  var ans = int.inf
  for d in 0 .. 9:
    ct := Seq[10:0]
    var ans0 = -int.inf
    for i in N:
      ct[pos[i][d]].inc
    for d in 0..9:
      if ct[d] > 0:
        ans0.max= d + (ct[d] - 1) * 10
    ans.min=ans0
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

