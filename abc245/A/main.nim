const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int, C:int, D:int):
  if A < C:
    echo "Takahashi"
  elif A > C:
    echo "Aoki"
  elif B < D:
    echo "Takahashi"
  elif B > D:
    echo "Aoki"
  else:
    echo "Takahashi"
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(A, B, C, D)
else:
  discard

