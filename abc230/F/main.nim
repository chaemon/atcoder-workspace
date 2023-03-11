const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/segtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, A:seq[int]):
  var
    S = A.sum
    prev = initTable[int, int]()
    st = initSegTree(N + 1, (a, b:mint)=>a+b, ()=>mint(0))
    s = 0
    ans = mint(0)
  prev[0] = 0
  st[0] = 1
  for i in N:
    s += A[i]
    if s in prev:
      st[i + 1] = st[prev[s] .. i]
    else:
      st[i + 1] = st[0 .. i]
    if s == S:
      ans += st[i + 1]
    prev[s] = i + 1
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

