include atcoder/extra/header/chaemon_header

proc solve(N:int, A:seq[int], B:seq[int]) =
  var even, odd = newSeq[int]()
  for i in 0..<N:
    if i mod 2 == 0:even.add(A[i] - B[i])
    else: odd.add(A[i] - B[i])
  even.sort()
  odd.sort()
  even.reverse()
  odd.reverse()
  var s = B.sum
  var ans = -int.inf
  for c in 0..N div 2:
    ans.max=s
    if c <= odd.len and c <= even.len:
      s += odd[c] + even[c]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
#}}}
