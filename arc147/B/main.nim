const
  DO_CHECK = true
  DEBUG = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, P:seq[int]):
  var P = P
  proc isIllegal(i:int):bool =
    i mod 2 != P[i] mod 2
  ans := Seq[(string, int)]
  for i in N:
    if not isIllegal(i): continue
    var j = i + 1
    while true:
      if isIllegal(j):
        break
      j += 2
      doAssert j < N
    let p = P[j]
    # P[j]をP[i + 1]に持ってくる
    while j != i + 1:
      swap P[j - 2], P[j]
      ans.add ("B", j - 2)
      j -= 2
    doAssert P[i + 1] == p
    swap P[i], P[i + 1]
    ans.add ("A", i)
  for i in N:
    doAssert not isIllegal(i)
  debug P
  # bubble sort
  block:
    for i in 0 ..< N >> 2:
      var j = i
      while P[j] != i:
        j += 2
      while j != i:
        swap P[j - 2], P[j]
        ans.add ("B", j - 2)
        j -= 2
    debug P
  block:
    for i in 1 ..< N >> 2:
      var j = i
      while P[j] != i:
        j += 2
      while j != i:
        swap P[j - 2], P[j]
        ans.add ("B", j - 2)
        j -= 2
    debug P
  echo ans.len
  for (s, i) in ans:
    echo s, " ", i + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P.pred)
else:
  discard

