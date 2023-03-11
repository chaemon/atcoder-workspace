include atcoder/extra/header/chaemon_header


proc solve(n:int) =
  var
    ans = 0
    s = 0
    i = 1
  while true:
    if s + i > n + 1: break
    s += i
    ans.inc
    i.inc
  echo min(n, n + 1 - ans)
  return

# input part {{{
block:
  var n = nextInt()
  solve(n)
#}}}
