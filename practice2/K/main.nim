include atcoder/header
#import atcoder/modint as modint_lib
import atcoder/extra/math/modint_montgomery
#import atcoder/lazysegtree
import atcoder/extra/structure/universal_segtree

const MOD = 998244353

#endif  // ATCODER_LAZYSEGTREE_HPP

useMontgomery(mint, MOD)

block:
  #  type mint = modint998244353
  #  mint.setMod(MOD)
  
  
  type S = tuple[a:mint, size:int]
  type F = tuple[a:mint, b:mint]
    
  #  proc op(l, r:S):S = (l.a + r.a, l.size + r.size)
  #  proc e():S = (mint(0), 0)
  #  proc mapping(l:F, r:S):S = (r.a * l.a + r.size * l.b, r.size)
  #  proc composition(l, r:F):F = (r.a * l.a, r.b * l.a + l.b)
  #  proc id():F = (mint(1), mint(0))
    
  let n, q = nextInt()
  let a = newSeqWith(n, (mint(nextInt()), 1))
  
  #  var seg = init_lazy_segtree(a, op, e, mapping, composition, id)
  
  var seg = init_lazy_segtree(a,
    (l:S, r:S) => (l.a + r.a, l.size + r.size), 
    () => (mint(0), 0),
    (l:F, r:S) => (r.a * l.a + r.size * l.b, r.size),
    (l:F, r:F) => (r.a * l.a, r.b * l.a + l.b),
    () => (mint(1), mint(0))
  )
  
  for i in 0..<q:
    let t = nextInt()
    if t == 0:
      let l, r, c, d = nextInt()
      seg.apply(l..<r, (mint(c), mint(d)))
    else:
      let l, r = nextInt()
      echo seg.prod(l..<r)[0]
