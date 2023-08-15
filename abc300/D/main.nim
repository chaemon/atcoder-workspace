when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/math/eratosthenes

solveProc solve(N:int):
  var
    e = initEratosthenes()
    ps:seq[int]
    ans = 0
  for p in e.enumPrime:
    if p * p > N: break
    ps.add p
  for i in ps.len:
    let a = ps[i]
    if a^5 > N: break
    for j in i + 1 ..< ps.len:
      let b = ps[j]
      if a^2 * b^3 > N: break
      let u = (int)(sqrt(N / (a * a * b)) + 1e-9)
      # psからbより大きくu以下を探す
      ans += ps.upperBound(u) - ps.upperBound(b)
  echo ans
when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

