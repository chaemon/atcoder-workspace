include atcoder/extra/header/chaemon_header

import atcoder/extra/other/binary_search

const DEBUG = true

#proc solve(K:int, N:int, M:int, A:seq[int]) =
#  var ans_B = Seq[int]
#  proc calc(m:int):bool =
#    var B = Seq[K: int]
#    var both_i = Seq[int]
#    for i in 0..<K:
#      if M * A[i] mod N == 0:
#        let Bi = M * A[i] div N
#        B[i] = Bi
#      else:
#        let Bi = M * A[i] div N
#        let d = abs(N * Bi - M * A[i])
#        assert N * Bi - M * A[i] > 0
#        let Bi2 = Bi + 1
#        let d2 = abs(N * Bi2 - M * A[i])
#        assert N * Bi2 - M * A[i] < 0
#        if d <= m:
#          B[i] = Bi
#          if d2 <= m:
#            both_i.add(i)
#        elif d2 <= m:
#          B[i] = Bi2
#        else:
#          return false
#    let S = B.sum
#    let d = M - S
#    assert d >= 0
#    if d > both_i.len: return false
#    for i in 0..<d:
#      B[both_i[i]].inc
#    swap(B, ans_B)
#    return true
#  let u = calc.minLeft(0..(int.inf))
#  assert calc(u)
#  echo ans_B.join(" ")
#  return


proc solve(K:int, N:int, M:int, A:seq[int]) =
  var ans_B = Seq[int]
  var B = Seq[K: int]
  var both_i = Seq[int]
  var v = Seq[K: tuple[d, i:int]]
  for i in 0..<K:
    if M * A[i] mod N == 0:
      let Bi = M * A[i] div N
      B[i] = Bi
    else:
      let Bi = M * A[i] div N
      let d = N * Bi - M * A[i]
      assert d < 0
      B[i] = Bi
      v.add((-d, i))
  v.sort()
  v.reverse()
  let S = B.sum
  let d = M - S
  assert d <= v.len
  for i in 0..<d:
    B[v[i].i].inc
  echo B.join(" ")
  return

# input part {{{
block:
  var K = nextInt()
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(K, nextInt())
  solve(K, N, M, A)
#}}}

