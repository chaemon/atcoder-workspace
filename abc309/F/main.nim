when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import sugar

import atcoder/segtree

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, h:seq[int], w:seq[int], d:seq[int]):
  var a:seq[seq[int]]
  for i in N:
    a.add @[h[i], w[i], d[i]].sorted
  a.sort
  # インデックス1を圧縮
  var v:seq[int]
  for i in N:
    v.add a[i][1]
  v.sort()
  v = v.deduplicate(isSorted = true)
  for i in N:
    a[i][1] = v.lower_bound(a[i][1])
  var
    st = initSegTree[int](v.len, (a, b:int) => min(a, b), () => int.inf)
    i = 0
  while i < N:
    var j = i
    while j < N and a[j][0] == a[i][0]: j.inc
    for k in i ..< j:
      if st[0 ..< a[k][1]] < a[k][2]:
        echo YES;return
    for k in i ..< j:
      st[a[k][1]] = min(st[a[k][1]], a[k][2])
    i = j
  echo NO
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var h = newSeqWith(N, 0)
  var w = newSeqWith(N, 0)
  var d = newSeqWith(N, 0)
  for i in 0..<N:
    h[i] = nextInt()
    w[i] = nextInt()
    d[i] = nextInt()
  solve(N, h, w, d)
else:
  discard

