include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int) =
  var A = 0
  while true:
    if A^2 > N: break
    A.inc
  A.dec
  echo A
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

