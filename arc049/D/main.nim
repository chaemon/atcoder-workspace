include atcoder/extra/header/chaemon_header


proc solve(N:int, Q:int, t:seq[int], a:seq[int], b:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, Q, t, a, b)
#}}}
