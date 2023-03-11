include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(A:int, B:int) =
  echo (1.0 - B.float / A.float) * 100.0
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

