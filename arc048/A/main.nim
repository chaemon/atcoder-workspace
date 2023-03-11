include atcoder/extra/header/chaemon_header


proc solve(A:int, B:int) =
  if B < 0 or A > 0:
    echo B - A
  else:
    echo B - A - 1
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}
