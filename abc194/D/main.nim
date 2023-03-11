include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int) =
  var s = 0.0
  for k in 1..N-1:
    s += (N - k) / (N * (k / N - 1.0)^2)
  echo s
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

