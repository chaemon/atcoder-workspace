const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, Y:int, Z:int, A:seq[int], B:seq[int]):
  var passed = initSet[int]()
  block:
    var v = Seq[(int, int)]
    for i in N:
      if i notin passed:
        v.add (-A[i], i)
    v.sort
    v = v[0 ..< X]
    for (a, i) in v:
      passed.incl i
  block:
    var v = Seq[(int, int)]
    for i in N:
      if i notin passed:
        v.add (-B[i], i)
    v.sort
    v = v[0 ..< Y]
    for (a, i) in v:
      passed.incl i
  block:
    var v = Seq[(int, int)]
    for i in N:
      if i notin passed:
        v.add (-A[i]-B[i], i)
    v.sort
    v = v[0 ..< Z]
    for (a, i) in v:
      passed.incl i
  var s = passed.toSeq.sorted
  echo s.succ.join("\n")
  discard

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var Z = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, X, Y, Z, A, B)
else:
  discard

