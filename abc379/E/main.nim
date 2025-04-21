when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum

solveProc solve(N:int, S:string):
  var cs = initDualCumulativeSum[int](N)
  for i,d in S:
    let
      d = d - '0'
      l = i + 1
      r = N - i
    cs.add(0 ..< r , l * d)
  var
    c = 0
    ans = ""
    i = 0
  while true:
    if i < N:
      c += cs[i]
    ans.add '0' + c % 10
    c.div=10
    if i >= N and c == 0: break
    i.inc
  var z = ans.len - 1
  while ans[z] == '0': z.dec
  ans = ans[0 .. z]
  ans.reverse
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

