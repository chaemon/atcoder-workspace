include atcoder/extra/header/chaemon_header


proc solve(N:int, x:seq[int], y:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var x = newSeqWith(N-1, 0)
  var y = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
#}}}
