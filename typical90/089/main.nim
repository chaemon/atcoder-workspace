const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/structure/set_map
import atcoder/segtree

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, K:int, A:seq[int]):
  var
    s = initSortedMultiSet[int]()
    l = 0
    inverse = 0
    st = initSegTree[mint](N + 1, (a, b:mint) => a + b, () => mint(0))
  st[0] = mint(1)
  for i in N:
    # l .. i
    # iを追加する
    inverse += distance(s.upperBound(A[i]), s.end())
    s.incl A[i]
    while s.len > 0 and inverse > K:
      # lを除く
      var it = s.lowerBound(A[l])
      inverse -= distance(s.begin(), it)
      s.excl it
      l.inc
    st[i + 1] = st[l .. i]
  echo st[N]
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
