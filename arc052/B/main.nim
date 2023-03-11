include atcoder/extra/header/chaemon_header


proc solve(N:int, Q:int, X:seq[int], R:seq[int], H:seq[int], A:seq[int], B:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var Q = nextInt()
  var X = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  var H = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    R[i] = nextInt()
    H[i] = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, Q, X, R, H, A, B)
#}}}
