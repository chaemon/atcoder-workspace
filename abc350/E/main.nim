when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:int, X:int, Y:int):
  var a = initTable[int, float]()
  proc calc(n:int):float =
    if n in a: return a[n]
    elif n == 0: return 0.0
    result = inf(float)
    result.min= calc(n div A) + float(X)
    var s = 0.0
    # b > 1の場合の和をs
    for b in 2 .. 6:
      s += calc(n div b)
    s /= 6
    # e = 1/6 * e + s + Y
    # e = 6 / 5 * (s + Y)
    result.min= 6.0 / 5.0 * (s + float(Y))
    a[n] = result
  echo calc(N)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var X = nextInt()
  var Y = nextInt()
  solve(N, A, X, Y)
else:
  discard

