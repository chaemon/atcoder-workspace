include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(X:int) =
  let r = X mod 100
  echo 100 - r
  return

# input part {{{
block:
  var X = nextInt()
  solve(X)
#}}}

