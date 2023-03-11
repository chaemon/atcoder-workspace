include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(A:int, B:int, W:int) =
  mini := int.inf
  maxi := -int.inf
  for t in 1..1000000:
    if W * 1000 in t * A .. t * B:
      mini.min=t
      maxi.max=t
  if mini == int.inf: echo "UNSATISFIABLE"
  else: echo mini, " ", maxi
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var W = nextInt()
  solve(A, B, W)
#}}}

