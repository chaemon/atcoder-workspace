const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/dsu, atcoder/convolution
import lib/math/combination

solveProc solve(N:int, A:seq[int]):
  var A = A
  for u in N:
    if A[u] != -1: A[u].dec
  var
    d = initDSU(N)
    cycle = Seq[N: false]
    sz = Seq[N: 1]
  for u in N:
    if A[u] == -1:
      continue
    let (l, r) = (d.leader(u), d.leader(A[u]))
    if l == r:
      cycle[l] = true
    else:
      let
        s = sz[l] + sz[r]
        c = cycle[l] or cycle[r]
      d.merge(u, A[u])
      let
        l2 = d.leader(u)
      sz[l2] = s
      cycle[l2] = c
  var
    vis = Seq[N: false]
    c = A.count(-1)
    ans = mint(0)
    v:seq[seq[mint]]
  for u in N:
    let l = d.leader(u)
    if vis[l]: continue
    vis[l] = true
    if cycle[l]: ans += mint(N)^c
    else:
      v.add @[mint(1), mint(sz[l])]
  if v.len >= 1:
    var dq = initDeque[seq[mint]]()
    for v in v: dq.addLast v
    while dq.len > 1:
      let p, q = dq.popFirst
      dq.addLast p.convolution(q)
    var t = dq.popFirst
    for n in 1..<t.len:
      ans += t[n] * mint.fact(n - 1) * mint(N)^(c - n)
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

