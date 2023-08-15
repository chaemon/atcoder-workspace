const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(H:int, W:int):
  if H == 1:
    echo W
  elif W == 1:
    echo H
  else:
    echo ((H + 1) div 2) * ((W + 1) div 2)
  return

# input part {{{
when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  solve(H, W)
#}}}

