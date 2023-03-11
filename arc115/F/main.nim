include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, h:seq[int], u:seq[int], v:seq[int], K:int, s:seq[int], t:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var h = newSeqWith(N, nextInt())
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  var K = nextInt()
  var s = newSeqWith(K, 0)
  var t = newSeqWith(K, 0)
  for i in 0..<K:
    s[i] = nextInt()
    t[i] = nextInt()
  solve(N, h, u, v, K, s, t)
#}}}

