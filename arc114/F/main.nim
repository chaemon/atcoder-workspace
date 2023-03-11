include atcoder/extra/header/chaemon_header

import atcoder/segtree
import atcoder/extra/structure/set_map

const DEBUG = true

proc `<`(a, b:seq[int]):bool = a[0] < b[0]

proc solve(N:int, K:int, P:seq[int]) =
  var ans = newSeq[int]()
  if P[0] < K:
    a := newSeq[seq[int]]()
    var i = 0
    while i < N:
      assert P[i] < K
      j := i + 1
      while j < N and P[j] >= K: j.inc
      a.add(P[i..<j])
      i = j
    a.sort(SortOrder.Descending)
    for a in a:
      ans &= a
  else:
    proc gen_ans(i, k:int):seq[int] =
      var ans = newSeq[int]()
      a := newSeq[seq[int]]()
      prev := N
      for j in countdown(N - 1, i):
        if P[j] < P[i]:
          a.add(P[j ..< prev])
          prev = j
          if a.len == k: break
      a.add(P[0 ..< prev])
      a.sort(SortOrder.Descending)
      for a in a:
        ans &= a
      return ans
    st := SegTree.getType(int, (a, b:int)=>max(a, b), () => -int.inf).init(N)
    st[P[0]] = 0
    v := Seq(N, int)
    for i in 1..<N:
      v[i] = st[P[i] + 1..<N] + 1
      st[P[i]] = v[i]
    s := initSortedSet[int]()
    for i in countdown(N - 1, 0):
      let u = s.lowerBound(P[i])
      if v[i] + 1 + u >= K:
        ans = gen_ans(i, K - (v[i] + 1))
        break
      s.insert(P[i])


  for a in ans.mitems: a.inc
  echo ans.join(" ")
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  solve(N, K, P)
#}}}

