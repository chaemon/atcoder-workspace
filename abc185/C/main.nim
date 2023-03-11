include atcoder/extra/header/chaemon_header


proc solve(L:int) =
  var ans = 1
  for i in 0..<11:
    ans *= L - 1 - i
    ans = ans div (i + 1)
  echo ans
  return

# input part {{{
block:
  var L = nextInt()
  solve(L)
#}}}
