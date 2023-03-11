const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const B = 2 * 10^6

solveProc solve(N:int):
  var ans = 0
  for d in 1..B:
    # d <= N / i < d + 1
    # i * d <= N and N < i * (d + 1)
    var
      r = N.floorDiv d
      l = N.floorDiv(d + 1) + 1
    if l > r: continue
    # l..r
    if l > N: continue
    r = min(r, N)
    ans += (r - l + 1) * d
  for i in 1..<B:
    let t = N.floorDiv i
    if t > B:
      ans += t
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

