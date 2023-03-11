include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int) =
  if N mod 100 == 0:
    echo N div 100
  else:
    echo N div 100 + 1
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}

