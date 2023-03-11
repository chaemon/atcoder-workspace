include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(K:int) =
  ans := 0
  for A in 1..K:
    for B in 1..K:
      if A * B > K:break
      ans += K div (A * B)
  echo ans
  return

# input part {{{
block:
  var K = nextInt()
  solve(K)
#}}}

