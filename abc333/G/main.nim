when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

proc doAssertTLE(b:bool) =
  if not b:
    while true:
      discard

proc doAssertOLE(b:bool) =
  if not b:
    while true:
      stdout.write("Hello World")


include lib/header/chaemon_header
import atcoder/extra/math/bignumber

type BigFraction = object
  n, d: BigInt

proc `//`(n, d:BigInt):BigFraction = BigFraction(n:n, d:d)

proc `<`(x, y:BigFraction):bool =
  x.n * y.d - y.n * x.d < newBigInt(0)
proc `<=`(x, y:BigFraction):bool =
  x.n * y.d - y.n * x.d <= newBigInt(0)

proc `==`(x, y:BigFraction):bool =
  x.n * y.d - y.n * x.d == newBigInt(0)

proc `-`(x, y:BigFraction):BigFraction =
  (x.n * y.d - y.n * x.d) // (x.d * y.d)

proc floorDiv(x, y:BigInt):BigInt =
  doAssertTLE y > newBigInt(0) and x >= newBigInt(0)
  x div y

proc ceilDiv(x, y:BigInt):BigInt =
  doAssertOLE y > newBigInt(0) and x >= newBigInt(0)
  (x + y - 1) div y

proc solve(r_num:int, N:int) =
  var N = newBigInt(N)
  let
    y = newBigInt(10^18)
    r = newBigInt(r_num) // y
  var
    left = newBigInt(0) // newBigInt(1)
    right = newBigInt(1) // newBigInt(1)
  while true:
    let
      p = left.n + right.n
      q = left.d + right.d
      x = p // q
    # left < x < right
    if p > N or q > N:
      break
    if r.n * q < r.d * p: # r < x
      # left <= r < xである
      # 同じ状況が連続してk回起こるとすると
      # r.n / r.d  < (left.n * k + p) / (left.d * k + q)が必要
      # k * () < ()にする
      let k1 = (p * r.d - q * r.n).ceilDiv(r.n * left.d - r.d * left.n) - 1 # kの上限
      # left.d * k + q <= N
      let k2 = (N - q).floorDiv(left.d) # kの上限
      let k = min(k1, k2)
      right = (left.n * k + p) // (left.d * k + q)
    else:
      # x <= r < rightである
      # 同じ状況がk回起こるとすると
      # (right.n * k + p) / (right.d * k + q) <= r.n / r.d
      let k1 = (q * r.n - p * r.d).floorDiv(right.n * r.d - right.d * r.n)
      # right.d * k + q <= N
      let k2 = (N - q).floorDiv(right.d)
      let k = min(k1, k2)
      left = (right.n * k + p) // (right.d * k + q)
  var ans:BigFraction
  if r - left <= right - r:
    ans = left
  else:
    ans = right
  echo ans.n, " ", ans.d

when not DO_TEST:
  let
    r = nextString()
    N = nextInt()
    r_num = block:
      var r = r[2 .. ^1]
      while r.len < 18:
        r = r & '0'
      r.parseInt
  solve(r_num, N)
else:
  import random
  #let r = "0.31415926535897932"
  for _ in 100000:
    let r_num = random.rand(10^17 ..< 10^18)
    for n in 1 .. 10:
      let N = 10^n
      debug r_num, N
      solve(r_num, N)

