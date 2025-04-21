when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/sqrt_int

solveProc solve(N:int):
  #proc sqrt_i(n:int):int =
  #  var (l, r) = (1, 2 * 10^9)
  #  while r - l > 1:
  #    let mid = (l + r) div 2
  #    if mid * mid <= n:
  #      l = mid
  #    else:
  #      r = mid
  #  return l
  var
    v:seq[int]
    ans = sqrt_int(N)
  for b in 3 .. 61:
    let amax = int(pow(float(N), (1 / float(b))) + 1e-8)
    var a = 1
    while a <= amax:
      let t = a^b
      if t > N: break
      let u = sqrt_int(t)
      if u * u != t:
        v.add t
      a.inc
  v.sort
  v = v.deduplicate(isSorted = true)
  echo ans + v.len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

