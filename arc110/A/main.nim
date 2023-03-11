include atcoder/extra/header/chaemon_header

proc solve(N:int) =
  var a = 1
  for i in 1..30:
    a = lcm(a, i)
  echo a + 1
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
