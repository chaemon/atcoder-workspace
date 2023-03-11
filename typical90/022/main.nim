const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(A:int, B:int, C:int):
  g := gcd(A, gcd(B, C))
  echo (A /. g) - 1 + (B /. g) - 1 + (C /. g) - 1
  return

# input part {{{
when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}

