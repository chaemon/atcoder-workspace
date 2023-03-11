include atcoder/extra/header/chaemon_header


proc solve(A:int, B:int, C:int) =
  var v = [A, B, C].sorted
  echo v[1] + v[2]
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}
