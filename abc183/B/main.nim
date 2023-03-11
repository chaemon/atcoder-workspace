include atcoder/extra/header/chaemon_header


proc solve(S_x:int, S_y:int, G_x:int, G_y:int) =
  var S_x = S_x.float
  var S_y = S_y.float
  var G_x = G_x.float
  var G_y = -G_y.float
  let d = abs(S_y) / abs(G_y - S_y)
  let dx = (G_x - S_x) * d
  echo S_x + dx
  return

# input part {{{
block:
  var S_x = nextInt()
  var S_y = nextInt()
  var G_x = nextInt()
  var G_y = nextInt()
  solve(S_x, S_y, G_x, G_y)
#}}}
