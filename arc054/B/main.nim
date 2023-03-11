include atcoder/extra/header/chaemon_header

proc solve(P:float) =
  proc f(x:float):float = x + P * pow(2, -x/1.5)
  let x = max(log(1.0/(P * ln(2.0) * (1/1.5)), 2) * (- 1.5), 0.0)
  echo f(x)
  return

# input part {{{
block:
  var P = nextFloat()
  solve(P)
#}}}
