include atcoder/extra/header/chaemon_header


proc solve(H:int, W:int) =
  echo H * (W - 1) + W * (H - 1)
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  solve(H, W)
#}}}
