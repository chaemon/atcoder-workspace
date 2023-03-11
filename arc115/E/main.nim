include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

import atcoder/lazysegtree

type D = tuple[x:mint, l:int]
type L = tuple[reset:bool, a, b:mint] # ax + b

proc op(a, b:D):auto = (a.x + b.x, a.l + b.l)
proc mapping(l:L, d:D):auto =
  if l.reset: (mint(0), d.l)
  else: (l.a * d.x + l.b * d.l, d.l)

proc composition(a, b:L):auto =
  if a.reset: (true, mint(0), mint(0))
  elif b.reset: (false, mint(0), a.b)
  else: (false, a.a * b.a, a.a * b.b + a.b)

proc solve(N:int, A:seq[int]) =
  var C = (@[0] & A).sorted
  C.add(C[^1] + 1)
  let M = C.len - 1
  var st = initLazySegTree(M, op, ()=>(mint(0), 0), mapping, composition, ()=>(false, mint(1), mint(0)))
  for i in 0..<M:
    let l = C[i + 1] - C[i]
    d := mint(0)
    if i == M - 1: d = mint(1)
    st[i] = (d, l)
  for i in 0..<N:
    let j = C.binarySearch(A[i])
    let S = st.allProd.x
    st.apply(0..<j, (false, mint(-1), S))
    st.apply(j..<M, (true, mint(0), mint(0)))
  echo st.allProd.x

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

