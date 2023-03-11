include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(V:int, T:int, S:int, D:int) =
  if D notin T * V..S * V: echo YES
  else: echo NO
  return

# input part {{{
block:
  var V = nextInt()
  var T = nextInt()
  var S = nextInt()
  var D = nextInt()
  solve(V, T, S, D)
#}}}

