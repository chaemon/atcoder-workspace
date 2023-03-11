include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(X:int, Y:int) =
  var (X, Y) = (X, Y)
  if X > Y:swap(X, Y)
  if X + 3 > Y: echo YES
  else: echo NO
  return

# input part {{{
block:
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
#}}}
