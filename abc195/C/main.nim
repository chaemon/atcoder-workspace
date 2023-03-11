include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int) =
  ans := 0
  for a in [10^3,10^6,10^9,10^12,10^15]:
    if N < a: continue
    ans += N - a + 1
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

