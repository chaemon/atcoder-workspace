include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, M:int, X:seq[int], Y:seq[int]) =
  var s = initSet[int]()
  s.incl(N)
  var v = Seq[tuple[X, Y:int]]
  for i in 0..<M: v.add((X[i], Y[i]))
  v.sort()
  var i = 0
  while i < M:
    let x = v[i].X
    var candidate = Seq[int]
    var discandidate = Seq[int]
    var j = i
    while j < M and v[j].X == x:
      let Y = v[j].Y
      if Y in s: discandidate.add(Y)
      for c in [Y - 1, Y + 1]:
        if c notin 0..2*N: continue
        if c in s: candidate.add(Y)
      j.inc
    for c in discandidate:
      if c notin candidate:
        s.excl(c)
    for c in candidate: s.incl(c)
    i = j
  echo s.len
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, X, Y)
#}}}

