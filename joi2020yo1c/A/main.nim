include atcoder/extra/header/chaemon_header


proc solve(X:int, L:int, R:int) =
  echo X.clamp(L, R)
  return

# input part {{{
block:
  var X = nextInt()
  var L = nextInt()
  var R = nextInt()
  solve(X, L, R)
#}}}
