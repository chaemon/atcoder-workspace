include atcoder/extra/header/chaemon_header


proc solve(N:int, Q:int, A:seq[int], B:seq[int], S:string, s:seq[int], t:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N-1, 0)
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
  var S = nextString()
  var s = newSeqWith(Q, 0)
  var t = newSeqWith(Q, 0)
  for i in 0..<Q:
    s[i] = nextInt()
    t[i] = nextInt()
  solve(N, Q, A, B, S, s, t)
#}}}
