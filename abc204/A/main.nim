include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(x:int, y:int) =
  if x == y: echo x
  else: echo 3 - x - y
  return

# input part {{{
block:
  var x = nextInt()
  var y = nextInt()
  solve(x, y)
#}}}

