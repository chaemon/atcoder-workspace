include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, K:int) =
  ans := 0
  for i in 1..N:
    for j in 1..K:
      ans += i * 100 + j
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}

