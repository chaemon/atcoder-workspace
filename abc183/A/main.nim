include atcoder/extra/header/chaemon_header


proc solve(x:int) =
  if x >= 0:
    echo x
  else:
    echo 0
  return

# input part {{{
block:
  var x = nextInt()
  solve(x)
#}}}
