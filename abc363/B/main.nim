when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:int, P:int, L:seq[int]):
  var
    L = L
    t = 0
  while true:
    var ct = 0
    for i in N:
      if L[i] >= T:
        ct.inc
    if ct >= P:
      echo t;return
    for i in N:
      L[i].inc
    t.inc
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextInt()
  var P = nextInt()
  var L = newSeqWith(N, nextInt())
  solve(N, T, P, L)
else:
  discard

