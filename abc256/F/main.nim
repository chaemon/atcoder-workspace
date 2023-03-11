const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/segtree

type P = tuple[n, a, b, c:mint] # 0乗, 1乗, 2乗

proc shift(p:P, t:mint):P =
  result.n = p.n
  result.a = p.a
  result.b = p.b + t * p.a # (n + t)
  result.c = p.c + (2 * t) * p.b + t * t * p.a # (n + t)^2

proc op(l, r:P):P =
  var l = l.shift(r.n)
  return (l.n + r.n, l.a + r.a, l.b + r.b, l.c + r.c)

proc e():P = (mint(0), mint(0), mint(0), mint(0))

# Failed to predict input format
solveProc solve(N, Q:int, A:seq[int]):
  var st = initSegTree[P](N, op, e)
  for i in N:
    let v = mint(A[i])
    st[i] = (mint(1), v, v, v)
  for i in Q:
    let t = nextInt()
    if t == 1:
      let x = nextInt() - 1
      let v = mint(nextInt())
      st[x] = (mint(1), v, v, v)
    else:
      let x = nextInt() - 1
      let (n, a, b, c) = st[0..x]
      echo (b + c) / 2
  discard

when not DO_TEST:
  let
    N, Q = nextInt()
    A = Seq[N: nextInt()]
  solve(N, Q, A)
else:
  discard

