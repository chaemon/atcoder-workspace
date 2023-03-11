include atcoder/extra/header/chaemon_header


proc solve(A:int, B:int, C:int) =
  var (A, B) = (A, B)
  if C == 1:
    A.inc
  if A <= B:
    echo "Aoki"
  else:
    echo "Takahashi"
  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C)
#}}}
