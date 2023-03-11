include atcoder/extra/header/chaemon_header


proc solve(N:int, Q:int, a:seq[int], b:seq[int], p:seq[int], x:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
  var p = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    p[i] = nextInt()
    x[i] = nextInt()
  solve(N, Q, a, b, p, x)
#}}}
