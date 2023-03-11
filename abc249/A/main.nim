const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int, C:int, D:int, E:int, F:int, X:int):
  proc calc(A, B, C:int):int =
    var X = X
    while X > 0:
      if X >= A + C:
        result += A * B
        X -= A + C
      elif X >= A:
        result += A * B
        X -= A
        return
      else:
        result += X * B
        return
  let
    t = calc(A, B, C)
    a = calc(D, E, F)
  if t > a:
    echo "Takahashi"
  elif t < a:
    echo "Aoki"
  else:
    echo "Draw"
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  var E = nextInt()
  var F = nextInt()
  var X = nextInt()
  solve(A, B, C, D, E, F, X)
else:
  discard

