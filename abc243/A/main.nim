const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(V:int, A:int, B:int, C:int):
  var V = V
  while true:
    if V < A:
      echo "F";return
    V -= A
    if V < B:
      echo "M";return
    V -= B
    if V < C:
      echo "T";return
    V -= C
  discard

when not DO_TEST:
  var V = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(V, A, B, C)
else:
  discard

