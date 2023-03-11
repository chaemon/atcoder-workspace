include atcoder/extra/header/chaemon_header


proc solve(S:string, T:string) =
  if S[0] == 'Y':
    echo T.toUpper
  else:
    echo T
  return

# input part {{{
block:
  var S = nextString()
  var T = nextString()
  solve(S, T)
#}}}
