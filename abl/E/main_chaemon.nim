include atcoder/extra/header/chaemon_header
import atcoder/lazysegtree
import atcoder/modint

const MOD = 998244353
var N:int
var Q:int
var L:seq[int]
var R:seq[int]
var D:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  Q = nextInt()
  L = newSeqWith(Q, 0)
  R = newSeqWith(Q, 0)
  D = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt() - 1
    R[i] = nextInt()
    D[i] = nextInt()
#}}}

type mint = modint998244353

type S = tuple[s:mint, p:mint, f:mint]
type F = int

proc op(a, b:S):S =
  (a.s * b.p + b.s, a.p * b.p, a.f * b.p + b.f)

proc e():S = (mint(0), mint(10), mint(1))

proc mapping(f:F, x:S):S =
  if f != -1: return (mint(f) * x.f, x.p, x.f)
  return x

proc composition(f:F, g:F):int =
  if f != -1: return f
  else: return g

proc id():F = -1

proc main() =
  var st = initLazySegTree(newSeqWith(N, (mint(1), mint(10), mint(1))), op, e, mapping, composition, id)
  let u = mint(10).pow(st.size - st.n)
  for i in 0..<Q:
    st.apply(L[i]..<R[i], D[i])
    echo st.all_prod()[0] / u
  var ans = mint(0)
  return

main()

