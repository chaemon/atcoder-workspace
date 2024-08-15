const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/segtree

solveProc solve(N:int, A:seq[int]):
  proc calc(A:seq[int]):seq[int] =
    result = Seq[N: 0]
    var a = sorted(A).deduplicate(isSorted = true)
    var st = initSegTree[int](a.len, (a, b:int) => max(a, b), () => 0)
    for i in A.len:
      var t = a.lowerBound(A[i])
      let u = st[0 ..< t] + 1
      result[i] = u
      st[t] = max(st[t], u)
  var
    v = calc(A)
    w = calc(A.reversed)
    ans = -int.inf
  w.reverse
  for i in N:
    ans.max= v[i] + w[i] - 1
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

