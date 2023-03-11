include atcoder/extra/header/chaemon_header


proc solve(A:int, B:int) =
  echo max(A + B, A - B)
  echo min(A + B, A - B)
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}
