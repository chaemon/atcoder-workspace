when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/math

proc extGCD(a, b:int, x, y: var int):int =
  if b == 0:
    x = 1
    y = 0
    return a
  let d = extGCD(b, a mod b, y, x)
  y -= (a div b) * x
  return d

# (X, Y), (A, B)のとき
# X * B - Y * A

solveProc solve(X:int, Y:int):
  shadow X, Y
  mX := false
  mY := false
  if X < 0: mX = true
  if Y < 0: mY = true
  var A, B:int
  let g = extGcd(abs(X), abs(Y), B, A)
  # pX + qY = 1
  if g > 2:
    echo -1;return
  A *= -1
  if mX: B *= -1
  if mY: A *= -1
  if g == 1:
    B *= 2
    A *= 2

  doAssert A in -(10^18) .. 10^18
  doAssert B in -(10^18) .. 10^18
  #doAssert A * X - B * Y == 2
  echo A, " ", B
  discard

when not defined(DO_TEST):
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
else:
  discard

