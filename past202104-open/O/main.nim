include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, M:int, a:seq[int], b:seq[int], Q:int, u:seq[int], v:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  var Q = nextInt()
  var u = newSeqWith(Q, 0)
  var v = newSeqWith(Q, 0)
  for i in 0..<Q:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, a, b, Q, u, v)
#}}}

