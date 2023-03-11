when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/structure/universal_segtree

type P = tuple[v: int, a:seq[int]]

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var
    st0 = initSegTree[bool](N, (a, b:bool) => a or b, () => false)
    st1 = initDualSegTree[int](A, (a, b:int) => a + b, () => 0)
  var
    v:seq[P] = block:
      var t = initTable[int, seq[int]]()
      for i in N:
        t[B[i]].add i
      var v = toSeq(t.pairs)
      v.sort(SortOrder.Descending)
      v
    ans = 0
  for (b, id) in v:
    for i in id:
      let s = st1[i]
      if s < 0: continue
      let
        l = st0.minLeft(i, (a:bool) => a == false)
        r = st0.maxRight(i, (a:bool) => a == false)
      # l .. rにs回
      debug l, r, b, s
      ans += b * s
      st1.apply(l ..< r, -s)
    for i in id:
      st0[i] = true
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
else:
  discard
