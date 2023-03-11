include atcoder/extra/header/chaemon_header


proc solve(A:int, B:int, C:int) =
  if C in A..<B: echo 1
  else: echo 0
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}
