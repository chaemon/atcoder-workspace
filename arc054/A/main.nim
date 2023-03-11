include atcoder/extra/header/chaemon_header


proc solve(L:int, X:int, Y:int, S:int, D:int) =
  var f = D - S
  if f < 0:f += L
  let b = L - f
  var ans = f / (X + Y)
  if Y > X: ans.min= b / (Y - X)
  echo ans
  return

# input part {{{
block:
  var L = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var S = nextInt()
  var D = nextInt()
  solve(L, X, Y, S, D)
#}}}
