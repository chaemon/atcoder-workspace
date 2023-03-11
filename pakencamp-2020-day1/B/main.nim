include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(X:int) =
  X := X
  ans := 0
  while X > 0:
    ans.max=X mod 10
    X = X div 10
  echo ans
  return

# input part {{{
block:
  var X = nextInt()
  solve(X)
#}}}

