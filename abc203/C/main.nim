include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, K:int, A:seq[int], B:seq[int]) =
  var p = Seq[tuple[A, B:int]]
  for i in 0..<N: p.add((A[i], B[i]))
  p.sort
  var
    K = K
    v = 0
  for i in 0..<N:
    let (A, B) = p[i]
    # v to A[i]
    let d = A - v
    if K < d:
      echo v + K;return
    K += B
    K -= d
    v = A
  v += K
  echo v
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, K, A, B)
#}}}

