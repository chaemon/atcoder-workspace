include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

const DEBUG = true

proc solve(A:int, B:int, C:int) =
  echo if A^2 + B^2 < C^2: YES else: NO
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}

