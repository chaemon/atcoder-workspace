include atcoder/extra/header/chaemon_header


proc solve(N:int, x:seq[int]) =
  var
    a:int
    b:float
    c = -int.inf
  for i in 0..<N:
    a += abs(x[i])
    b += (x[i] * x[i]).float
    c.max=x[i].abs
  b = sqrt(b)
  echo a, " ", b, " ", c
  return

# input part {{{
block:
  var N = nextInt()
  var x = newSeqWith(N, nextInt())
  solve(N, x)
#}}}
