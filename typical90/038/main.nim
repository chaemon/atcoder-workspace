const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import BigNum


solveProc solve(A:int, B:int):
  let g = gcd(A, B)
  let l = newInt(A) * B div g
  if l > 10^18: echo "Large"
  else: echo l
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

