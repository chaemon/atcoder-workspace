const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/compress
import atcoder/segtree

type P = tuple[A, B:int]

proc `<`(a, b:P):bool =
  if a.A != b.A: return a.A < b.A
  if a.B != b.B: return a.B > b.B
  return false

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var ct = initTable[(int, int), int]()
  var c = initCompress(B)
  var v = Seq[P]
  for i in N: v.add((A[i], B[i]));ct[(A[i], B[i])].inc
  v.sort
  var st = initSegTree(c.len, (a, b:int) => a + b, () => 0)
  var ans = 0
  for i in 0..<N:
    let t = c.id(v[i].B)
    ans += st[t .. ^1]
    st[t] = st[t] + 1
  for k, v in ct:
    if v >= 2:
      ans += v * (v - 1) div 2
  echo ans + N
  Naive:
    ans := 0
    for i in N: # takahashi
      for j in N: # aoki
        if A[i] >= A[j] and B[i] <= B[j]: ans.inc
    echo ans
  return

when not DO_TEST:
  let N = nextInt()
  let A = Seq[N:nextInt()]
  let B = Seq[N:nextInt()]
  solve(N, A, B)
else:
  import random
  const N = 4
  for a in 0..3:
    for b in 0..3:
      for c in 0..3:
        for d in 0..3:
          for e in 0..3:
            for f in 0..3:
              for g in 0..3:
                for h in 0..3:
                  var A = @[a, b, c, d]
                  var B = @[e, f, g, h]
                  test(N, A, B)

