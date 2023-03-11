const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/other/compress
import atcoder/lazysegtree

op(a, b:mint) => a + b
e() => mint(0)
mapping(f, s:mint) => f * s
composition(f, g:mint) => f * g
id0() => mint(1)

solveProc solve(N:int, A:seq[int]):
  var c = initCompress[int]()
  for a in A:c.add a
  c.build
  var st = initLazySegTree(c.len, op, e, mapping, composition, id0)
  var ans = mint(0)
  for a in A:
    let i = c{a}
    ans += st[0..i]
    st.allApply(mint(2))
    st[i] = st[i] + 1
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

