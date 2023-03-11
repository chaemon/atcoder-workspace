include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(M:int, H:int) =
  if H mod M == 0: echo YES
  else: echo NO
  return

# input part {{{
block:
  var M = nextInt()
  var H = nextInt()
  solve(M, H)
#}}}

