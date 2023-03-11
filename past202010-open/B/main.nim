include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(X:int, Y:int) =
  if Y == 0:
    echo "ERROR"
  else:
    let u = int(X * 100 / Y)
    echo fmt"{u / 100:.2f}"
  return

# input part {{{
block:
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
#}}}

