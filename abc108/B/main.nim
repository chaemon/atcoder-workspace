include atcoder/extra/header/chaemon_header


proc solve(x:seq[int], y:seq[int]) =
  return

# input part {{{
block:
  var x = newSeqWith(2, 0)
  var y = newSeqWith(2, 0)
  for i in 0..<2:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(x, y)
#}}}
