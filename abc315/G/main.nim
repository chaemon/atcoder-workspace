when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/math

solveProc solve(N:int, A:int, B:int, C:int, X:int):
  var g = gcd(A, B)
  let
    a = A div g
    b = B div g
  # ax + by = 1となるx, yを求める
  # ax ≡1 (mod b)
  var
    ans = 0
  let t = invMod(a, b)
  for k in 1 .. N:
    var X = X - C * k
    if X < 0 or X mod g != 0: continue
    X = X div g
    # ax + by = Xとなるx, yを求める。ただし、0 <= x < b
    # ax ≡X (mod b)
    let
      x = ((X mod b) * t) mod b
      y = (X - a * x) div b

    # 1 <= x - t * b <= N
    # 1 <= y + t * a <= N
    var
      tmin = -int.inf
      tmax = int.inf
    # x - N <= t * b
    tmin.max=(x - N) /^ b
    # t * b <= x - 1
    tmax.min=(x - 1) /. b
    # 1 - y <= t * a
    tmin.max=(1 - y) /^ a
    # t * a <= N - y
    tmax.min=(N - y) /. a
    if tmin <= tmax:
      ans += tmax - tmin + 1

  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var X = nextInt()
  solve(N, A, B, C, X)
else:
  discard

