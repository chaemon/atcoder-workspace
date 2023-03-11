include atcoder/extra/header/chaemon_header


proc solve(N:int) =
  if N mod 2 == 1:
    echo "Black"
  else:
    echo "White"
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
