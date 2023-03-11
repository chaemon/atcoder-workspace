include atcoder/extra/header/chaemon_header


proc solve(W:int, H:int, a:seq[int], b:seq[int], Q:int, A:seq[int], B:seq[int]) =
  return

# input part {{{
block:
  var W = nextInt()
  var H = nextInt()
  var a = newSeqWith(W, nextInt())
  var b = newSeqWith(H, nextInt())
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(W, H, a, b, Q, A, B)
#}}}
