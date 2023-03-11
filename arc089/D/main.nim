include atcoder/extra/header/chaemon_header


proc solve(N:int, K:int, x:seq[int], y:seq[int], c:seq[string]) =
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  var c = newSeqWith(N, "")
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
    c[i] = nextString()
  solve(N, K, x, y, c)
#}}}
