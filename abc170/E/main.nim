const DO_CHECK = false

include atcoder/extra/header/chaemon_header

import lib/structure/set_map

let M = 200000

solveProc solve(N:int, Q:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  var B = B
  var s = initSortedMultiSet(int)
  var rates = newSeq[SortedMultiSet(int)]()
  #static:
  #  echo T is SortedMultiSet(int)
  for _ in 0..<M:
    rates.add(initSortedMultiSet(int))
  v := newSeq[SortedMultiSet(int).Node](N)
  w := newSeq[SortedMultiSet(int).Node](M)
  for i in 0..<N:
    v[i] = rates[B[i]].insert(-A[i])
  for j in 0..<M:
    if rates[j].len > 0:
      h := - *rates[j].begin()
      w[j] = s.insert(h)
    else:
      w[j] = s.insert(int.inf)
  for q in 0..<Q:
    i := C[q]
    rates[B[i]].erase(v[i])
    s.erase(w[B[i]])
    if rates[B[i]].len > 0:
      h := - *rates[B[i]].begin()
      w[B[i]] = s.insert(h)
    else:
      w[B[i]] = s.insert(int.inf)
    s.erase(w[D[q]])
    v[i] = rates[D[q]].insert(-A[i])
    h := - *rates[D[q]].begin()
    w[D[q]] = s.insert(h)
    echo *s.begin()
    B[i] = D[q]
  return

# input part {{{
block:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    B[i].dec
  var C = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    C[i] = nextInt()
    D[i] = nextInt()
    C[i].dec
    D[i].dec
  solve(N, Q, A, B, C, D)
#}}}
