include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(X:string) =
  let t = X.find('.')
  if t == -1:
    echo X
  else:
    echo X[0..<t]
  return

# input part {{{
block:
  var X = nextString()
  solve(X)
#}}}

