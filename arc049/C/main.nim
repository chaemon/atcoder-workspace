include atcoder/extra/header/chaemon_header


proc solve(N:int, A:int, x:seq[int], y:seq[int], B:int, u:seq[int], v:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var A = nextInt()
  var x = newSeqWith(A, 0)
  var y = newSeqWith(A, 0)
  for i in 0..<A:
    x[i] = nextInt()
    y[i] = nextInt()
  var B = nextInt()
  var u = newSeqWith(B, 0)
  var v = newSeqWith(B, 0)
  for i in 0..<B:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, A, x, y, B, u, v)
#}}}
