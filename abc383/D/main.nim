when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/math/eratosthenes

const P = 2 * 10^6

solveProc solve(N:int):
  var
    es = initEratosthenes(P)
    ps:seq[int]
    ans = 0
  for p in 2 .. P:
    if es.isPrime(p):
      ps.add p
  var n = int(sqrt(float(N)) + 1e-9)
  #debug n
  # n = p * q (p < q)
  for i in ps.len:
    if ps[i]^4 <= n:
      ans.inc
    else:
      break
  for i in ps.len:
    # i + 1 ..< j
    let j = ps.upperBound(n div ps[i])
    if i + 1 < j:
      ans += j - (i + 1)
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

