include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, D:int, H:int, d:seq[int], h:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var D = nextInt()
  var H = nextInt()
  var d = newSeqWith(N, 0)
  var h = newSeqWith(N, 0)
  for i in 0..<N:
    d[i] = nextInt()
    h[i] = nextInt()
  solve(N, D, H, d, h)
#}}}

