when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, Y:int, A:seq[int]):
  var g = Seq[100000 + 1: int]
  g[0] = 0
  for i in 1 .. 100000:
    var s = initSet[int]()
    if i >= X:
      s.incl g[i - X]
    if i >= Y:
      s.incl g[i - Y]
    var j = 0
    while true:
      if j notin s: break
      j.inc
    g[i] = j
  s := 0
  for i in N:
    s.xor=g[A[i]]
  if s != 0:
    echo "First"
  else:
    echo "Second"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, Y, A)
else:
  discard

