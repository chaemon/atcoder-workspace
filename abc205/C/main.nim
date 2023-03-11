include atcoder/extra/header/chaemon_header


const DEBUG = true

solveProc solve(A:int, B:int, C:int):
  var t:int
  if C mod 2 == 1:
    if A < B: echo "<"
    elif A > B: echo ">"
    else: echo "="
  else:
    let
      A = abs(A)
      B = abs(B)
    if A < B: echo "<"
    elif A > B: echo ">"
    else: echo "="

  return

# input part {{{
block:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(A, B, C, true)
#}}}

