include atcoder/extra/header/chaemon_header


proc solve(N:int, X:int, S:string) =
  var a = X
  for s in S:
    if s == 'o':a.inc
    elif a > 0:a.dec
  echo a
  return

# input part {{{
block:
  var N = nextInt()
  var X = nextInt()
  var S = nextString()
  solve(N, X, S)
#}}}
