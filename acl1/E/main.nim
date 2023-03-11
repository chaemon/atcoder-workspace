include atcoder/extra/header/chaemon_header
#import atcoder/lazysegtree

# normal modint vs montgomery

import atcoder/modint
#import atcoder/extra/math/montgomery_modint

# segtree vs static_segtree

import atcoder/segtree
#import atcoder/dynamic_segtree

var N:int
var K:int
var p:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  p = newSeqWith(N, nextInt() - 1)
#}}}

type mint = modint998244353
#type mint = getMontgomeryType(998244353)

#declareMontgomery(mint, 998244353)
#declareMontgomery(mint0, 1000000007)

type S = tuple[n:int, s:mint]
#type F = mint

proc op(a, b:S):S =
  (a.n + b.n, a.s + b.s)
proc e():S = (0, mint(0))
#proc mapping(f:F, x:S):S = (x.n, x.s * f)
#proc composition(f, g:F):F = f * g
#proc id():F = mint(1)

#var st = initSegTree(N, op, e)
var st = initSegTree(N, (a:S, b:S)=>(a.n + b.n, a.s + b.s), ()=>(0, mint(0)))
#var st = segtree[S, (op:op, e:e)].init(N)

proc main() =
  let
    alpha = mint(K - 1)/K
    ialpha = alpha.inv()
    half = mint(1)/2
  var
    ans = mint(0)
    pr = mint(1)
    ipr = mint(1)
  for i in 0..<K:
    ans += st.all_prod().s * half
    st.set(p[i], (1, mint(1)))
  for i in K..<N:
    pr *= alpha
    ipr *= ialpha
#    st.apply(0..<N, alpha)
    ans += st.prod(0..<p[i]).s * half * pr
    let (n, t) = st.prod(p[i]..<N)
    # \sum (1 - alpha^k)/(1 - alpha) * (1 - alpha) + alpha^k * half
    ans += n - t * pr + t * half * pr
    st.set(p[i], (1, ipr))
  print ans
  return

#echo st.min_left(10, 13)

main()
