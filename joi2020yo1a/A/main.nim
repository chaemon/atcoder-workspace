include atcoder/extra/header/chaemon_header


proc solve(A:int, B:int, C:int) =
  let v = sorted([A, B, C])
  if v[0] == v[1]:
    echo v[0]
  else:
    echo v[2]
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}
