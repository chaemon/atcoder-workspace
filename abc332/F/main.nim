when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/lazysegtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

type
  S = mint
  F = tuple[a, b:mint] # x => ax + b

# a1 * (a2 * x + b2) + b1

op(a, b:S) => a + b
e() => mint(0)
mapping(f:F, s:S) => f.a * s + f.b
composition(f1, f2:F) => (f1.a * f2.a, f1.a * f2.b + f1.b)
id() => (mint(1), mint(0))

solveProc solve(N:int, M:int, A:seq[int], L:seq[int], R:seq[int], X:seq[int]):
  Pred L
  # L[i] ..< R[i]
  var st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
  for i in N:
    st[i] = A[i]
  for i in M:
    let p = 1 / mint(R[i] - L[i])
    st.apply(L[i] ..< R[i], (1 - p, p * X[i]))
  var E = collect(newSeq):
    for i in N: st[i]
  echo E.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  var X = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt()
    R[i] = nextInt()
    X[i] = nextInt()
  solve(N, M, A, L, R, X)
else:
  discard

