include atcoder/extra/header/chaemon_header

proc solve(N:int) =
  for i in 1..37:
    for j in 1..25:
      if 3^i + 5^j == N:
        echo i, " ", j;return
  echo -1
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
