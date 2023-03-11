include atcoder/extra/header/chaemon_header


proc solve(N:int, a:seq[int], b:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, a, b)
#}}}
