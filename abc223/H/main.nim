const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import bitops
import lib/other/bitutils
import atcoder/segtree

const YES = "Yes"
const NO = "No"

const B = 60

proc op(a, b:seq[int]):seq[int] =
  var v:array[B, seq[int]]
  for i in 0..<a.len: v[a[i].firstSetBit - 1].add(a[i])
  for i in 0..<b.len: v[b[i].firstSetBit - 1].add(b[i])
  for i in 0..<B:
    if v[i].len == 0: continue
    result.add(v[i][0])
    for j in 1..<v[i].len:
      var u = v[i][0] xor v[i][j]
      if u == 0: continue
      v[u.firstSetBit - 1].add(u)

solveProc solve(N:int, Q:int, A:seq[int], L:seq[int], R:seq[int], X:seq[int]):
  var st = initSegTree(N, op, () => newSeq[int]())
  for i in 0..<N: st[i] = @[A[i]]
  for i in 0..<Q:
    var v = st[L[i]..R[i]]
    var x = 0
    for j in 0..<v.len:
      let j0 = v[j].firstSetBit - 1
      if X[i][j0] != x[j0]:
        x = x xor v[j]
    if x != X[i]: echo NO
    else: echo YES
  return

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  var X = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt() - 1
    R[i] = nextInt() - 1
    X[i] = nextInt()
  solve(N, Q, A, L, R, X)
else:
  discard

