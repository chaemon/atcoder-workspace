const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(X:string, N:int, S:seq[string]):
  var rX = Seq[26: int]
  for i,s in X:
    rX[s.ord - 'a'.ord] = i
  var v = newSeq[seq[int]]()
  for s in S:
    var vs:seq[int]
    for s in s:
      vs.add(rX[s.ord - 'a'.ord])
    v.add(vs)
  v.sort
  for v in v:
    var s = ""
    for i in v:
      s.add X[i]
    echo s

  return

when not DO_TEST:
  var X = nextString()
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(X, N, S)
else:
  discard

