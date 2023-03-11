include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(A:int, B:int) =
  let C = A + B
  if C >= 15 and B >= 8:
    echo 1
  elif C >= 10 and B >= 3:
    echo 2
  elif C >= 3:
    echo 3
  else:
    echo 4
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
#}}}

