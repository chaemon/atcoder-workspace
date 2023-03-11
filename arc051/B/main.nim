include atcoder/extra/header/chaemon_header

proc solve(K:int) =
  var
    a = 1
    b = 0
  for _ in 0..K:
    (a, b) = (a + b, a)
  echo a, " ", b
  return

# input part {{{
block:
  var K = nextInt()
  solve(K)
#}}}
