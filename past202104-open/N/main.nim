include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, H:int, a:seq[int], b:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var H = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, H, a, b)
#}}}

