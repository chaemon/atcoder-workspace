when not declared ATCODER_HEADER_HPP:
  const ATCODER_HEADER_HPP* = 1
  {.hints:off checks:off assertions:on checks:off optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/streams as streams_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  proc getchar*(): char {.header: "<stdio.h>", varargs.}
  proc nextInt*(base:int = 0): int =
    scanf("%lld",addr result)
    result -= base
  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*(): string =
    var get = false;result = ""
    while true:
      var c = getchar()
      if int(c) > int(' '): get = true;result.add(c)
      elif get: break
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
#import atcoder/modint as modint_lib
when not declared ATCODER_MONTGOMERY_MODINT_HPP:
  const ATCODER_MONTGOMERY_MODINT_HPP* = 1

  import std/macros
  import std/strformat

  type LazyMontgomeryModInt*[M:static[uint32]] = object
    a:uint32

  proc get_r*(M:uint32):auto =
    result = M
    for i in 0..<4: result *= 2.uint32 - M * result
  proc get_n2*(M:uint32):auto = (((not M.uint) + 1.uint) mod M.uint).uint32

  proc reduce(b:uint, M: static[uint32]):uint32 =
    const r = get_r(M)
    return ((b + (cast[uint32](b) * ((not r) + 1.uint32)).uint * M.uint) shr 32).uint32
#    return ((b + (((b and MASK) * ((not r) + 1.uint32).uint) and MASK) * M.uint) shr 32).uint32
  proc `mod`*[T:LazyMontgomeryModInt](self:typedesc[T]):int = T.M.int
  proc `mod`*[T:LazyMontgomeryModInt](self:T):int = T.M.int

  template reduce(T:typedesc[LazyMontgomeryModInt], b:uint):auto =
    reduce(b, T.M)

  proc initLazyMontgomeryModInt*(b:SomeInteger = 0, M:static[SomeInteger]):auto {.inline.} =
    const M = M.uint32
    const r = get_r(M)
    const n2 = get_n2(M)
    static:
      assert r * M == 1, "invalid, r * mod != 1"
      assert M < (1 shl 30), "invalid, mod >= 2 ^ 30"
      assert (M and 1) == 1, "invalid, mod % 2 == 0"
    type T = LazyMontgomeryModInt[M]
    return T(a:reduce((b.int mod M.int + M.int).uint * n2, M, r))

  proc init*(T:typedesc[LazyMontgomeryModInt], b:T or SomeInteger):auto =
    const r = get_r(T.M)
    const n2 = get_n2(T.M)
    when b is uint:
      let b = (b mod T.M.uint).int
    when b is LazyMontgomeryModInt: b
    else:
      T(a:reduce((b.int mod T.M.int + T.M.int).uint * n2, T.M))

  macro useMontgomery*(name, M) =
    var strBody = ""
    strBody &= fmt"""type {name.repr}* = LazyMontgomeryModInt[{M.repr}.uint32]{'\n'}converter to{name.repr}OfMontgomery*(n:int):{name.repr} {{.used.}} = {name.repr}.init(n){'\n'}"""
    parseStmt(strBody)

  proc val*[T:LazyMontgomeryModInt](self: T):int =
    var a = T.reduce(self.a)
    if a >= T.M: a -= T.M
    a.int

  proc get_mod*[T:LazyMontgomeryModInt](self:T):auto = T.M

  proc `+=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a += b.a - 2.uint32 * T.M
    if cast[int32](self.a) < 0.int32: self.a += 2.uint32 * T.M
    return self

  proc `-=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a -= b.a
    if cast[int32](self.a) < 0.int32: self.a += 2.uint32 * T.M
    return self

  proc `*=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a = T.reduce(self.a.uint * b.a.uint)
    return self

  proc pow*[T:LazyMontgomeryModInt, N:SomeInteger](self: T, n:N):T {.inline.} =
    assert n >= N(0)
    result = T.init(1)
    var mul = self
    var n = n.uint
    while n > 0'u:
      if (n and 1'u) != 0'u: result *= mul
      mul *= mul
      n = n shr 1

  proc inv*[T:LazyMontgomeryModInt](self: T):T = self.pow(T.M - 2)

  proc `/=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self *= b.inv()
    return self

  template generateLazyMontgomeryModIntDefinitions(name, l, r, body: untyped): untyped {.dirty.} =
    proc name*(l, r: LazyMontgomeryModInt): auto {.inline.} =
      type T = l.type
      body
    proc name*(l: SomeInteger; r: LazyMontgomeryModInt): auto {.inline.} =
      type T = r.type
      body
    proc name*(l: LazyMontgomeryModInt; r: SomeInteger): auto {.inline.} =
      type T = l.type
      body

  generateLazyMontgomeryModIntDefinitions(`+`, m, n):
    result = T.init(m)
    result += T.init(n)

  generateLazyMontgomeryModIntDefinitions(`-`, m, n):
    result = T.init(m)
    result -= T.init(n)

  generateLazyMontgomeryModIntDefinitions(`*`, m, n):
    result = T.init(m)
    result *= T.init(n)

  generateLazyMontgomeryModIntDefinitions(`/`, m, n):
    result = T.init(m)
    result /= T.init(n)

  generateLazyMontgomeryModIntDefinitions(`==`, m, n):
    result = (T.init(m).val() == T.init(n).val())

  proc `$`*(m: LazyMontgomeryModInt): string {.inline.} = $(m.val())

  proc `-`*[T:LazyMontgomeryModInt](self:T):T = T.init(0) - self

  useMontgomery modint998244353, 998244353
  useMontgomery modint1000000007, 1000000007
#import atcoder/lazysegtree
when not declared ATCODER_LAZYSEGTREE_HPP:
  const ATCODER_LAZYSEGTREE_HPP* = 1
  
  import std/sugar
  import std/sequtils
  import std/bitops
  when not declared ATCODER_INTERNAL_BITOP_HPP:
    const ATCODER_INTERNAL_BITOP_HPP* = 1
    import std/bitops
  
  #ifdef _MSC_VER
  #include <intrin.h>
  #endif
  
  # @param n `0 <= n`
  # @return minimum non-negative `x` s.t. `n <= 2**x`
    proc ceil_pow2*(n:SomeInteger):int =
      var x = 0
      while (1.uint shl x) < n.uint: x.inc
      return x
  # @param n `1 <= n`
  # @return minimum non-negative `x` s.t. `(n & (1 << x)) != 0`
    proc bsf*(n:SomeInteger):int =
      return countTrailingZeroBits(n)
    discard
  type segtree[S,F,useP;p:static[tuple]] = object
    n, size, log:int
    when S isnot void:
      d:seq[S]
    when F isnot void:
      lz:seq[F]
      when useP isnot void:
        p:(F,Slice[int])->F
  proc hasData(ST:typedesc[segtree]):bool {.compileTime.} = ST.S isnot void
  proc hasLazy(ST:typedesc[segtree]):bool {.compileTime.} = ST.F isnot void
  proc hasP(ST:typedesc[segtree]):bool {.compileTime.} = ST.useP isnot void

  template calc_op[ST:segtree](self:typedesc[ST], a, b:ST.S):auto =
    block:
      let op = ST.p.op
      op(a, b)
  template calc_e[ST:segtree](self:typedesc[ST]):auto =
    block:
      let e = ST.p.e
      e()
  template calc_mapping[ST:segtree](self:typedesc[ST], a:ST.F, b:ST.S):auto =
    block:
      let mapping = ST.p.mapping
      mapping(a, b)
  template calc_composition[ST:segtree](self:typedesc[ST], a, b:ST.F):auto =
    block:
      let composition = ST.p.composition
      composition(a, b)
  template calc_id[ST:segtree](self:typedesc[ST]):auto =
    block:
      let id = ST.p.id
      id()
  template calc_p[ST:segtree](self:typedesc[ST], a:ST.F, s:Slice[int]):auto =
    block:
      let p = ST.p.p
      p(a, s)

  proc update*[ST:segtree](self:var ST, k:int) =
    self.d[k] = ST.calc_op(self.d[2 * k], self.d[2 * k + 1])
  proc all_apply*[ST:segtree](self:var ST, k:int, f:ST.F) =
    static: assert ST.hasLazy
    when ST.hasData:
      self.d[k] = ST.calc_mapping(f, self.d[k])
      if k < self.size: self.lz[k] = ST.calc_composition(f, self.lz[k])
    else:
      self.lz[k] = ST.calc_composition(f, self.lz[k])

  proc push*[ST:segtree](self: var ST, k:int) =
    static: assert ST.hasLazy
    when ST.hasP:
      let m = self.size shr (k.fastLog2 + 1)
    self.all_apply(2 * k    , when ST.hasP: self.p(self.lz[k], 0..<m    ) else: self.lz[k])
    self.all_apply(2 * k + 1, when ST.hasP: self.p(self.lz[k], m..<m + m) else: self.lz[k])
    self.lz[k] = ST.calc_id()

#  segtree(int n) : segtree(std::vector<S>(n, e())) {}
  proc init*[ST:segtree](self: var ST, v:int or seq[ST.S] or seq[ST.F]) =
    when v is int:
      when ST.hasData:
        self.init(newSeqWith(v, ST.calc_e()))
      else:
        self.init(newSeqWith(v, ST.calc_id()))
    else:
      let
        n = v.len
        log = ceil_pow2(n)
        size = 1 shl log
      self.n = n;self.log = log;self.size = size
      when ST.hasLazy:
        when ST.hasData:
          self.lz = newSeqWith(size, ST.calc_id())
        else:
          self.lz = newSeqWith(size * 2, ST.calc_id())
      when ST.hasData:
        self.d = newSeqWith(2 * size, ST.calc_e())
        for i in 0..<n: self.d[size + i] = v[i]
        for i in countdown(size - 1, 1): self.update(i)
      else:
        for i in 0..<n: self.lz[size + i] = v[i]

  proc init_segtree*[S](v:seq[S], op:static[(S,S)->S], e:static[()->S]):auto =
    result = segtree[S,void,void, (op:op,e:e)]()
    result.init(v)
  proc init_segtree*[S](n:int, op:static[(S,S)->S], e:static[()->S]):auto =
    let e0 = e
    var v = newSeqWith(n, e0())
    return init_segtree(v, op, e)
  proc init_dual_segtree*[F](v:seq[F], composition:static[(F,F)->F], id:static[()->F]):auto =
    result = segtree[void,F,void, (composition:composition,id:id)]()
    result.init(v)
  proc init_dual_segtree*[F](n:int, composition:static[(F,F)->F], id:static[()->F]):auto =
    let id0 = id
    init_dual_segtree[F](newSeqWith(n, id0()), composition, id)
  proc init_lazy_segtree*[S,F](v:seq[S], op:static[(S,S)->S],e:static[()->S],mapping:static[(F,S)->S],composition:static[(F,F)->F],id:static[()->F]):auto =
    result = segtree[S,F,void,(op:op,e:e,mapping:mapping,composition:composition,id:id)]()
    result.init(v)
  proc init_lazy_segtree*[S,F](n:int, op:static[(S,S)->S],e:static[()->S],mapping:static[(F,S)->S],composition:static[(F,F)->F],id:static[()->F]):auto =
    let e0 = e
    init_lazy_segtree[S,F](newSeqWith(n, e0()), op,e,mapping,composition,id)
  proc init_lazy_segtree*[S,F](v:seq[S], op:static[(S,S)->S],e:static[()->S],mapping:static[(F,S)->S],composition:static[(F,F)->F],id:static[()->F], p:static[(F,Slice[int])->F]):auto =
    result = segtree[S,F,int](op:op,e:e,mapping:mapping,composition:composition,id:id, p:p)
    result.init(v)
  proc init_lazy_segtree*[S,F](n:int, op:static[(S,S)->S],e:static[()->S],mapping:static[(F,S)->S],composition:static[(F,F)->F],id:static[()->F], p:static[(F,Slice[int])->F]):auto =
    let e0 = e
    init_lazy_segtree[S,F](newSeqWith(n, e0()), op,e,mapping,composition,id,p)

#  proc set*[ST:segtree](self: var ST, p:int, x:ST.S or ST.F) =
  proc set*[ST:segtree](self: var ST, p:int, x:auto) =
    assert p in 0..<self.n
    let p = p + self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1): self.push(p shr i)
    when ST.hasData:
      self.d[p] = x
      for i in 1..self.log: self.update(p shr i)
    else:
      self.lz[p] = x

  proc get*[ST:segtree](self: var ST, p:int):auto =
    assert p in 0..<self.n
    let p = p + self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1): self.push(p shr i)
    when ST.hasData:
      return self.d[p]
    else:
      return self.lz[p]

  proc prod*[ST:segtree](self:var ST, p:Slice[int]):ST.S =
    static: assert ST.hasData
    var (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    if l == r: return ST.calc_e()
    l += self.size;r += self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1):
        if ((l shr i) shl i) != l: self.push(l shr i)
        if ((r shr i) shl i) != r: self.push(r shr i)
    var sml, smr = ST.calc_e()
    while l < r:
      if (l and 1) != 0: sml = ST.calc_op(sml, self.d[l]);l.inc
      if (r and 1) != 0: r.dec;smr = ST.calc_op(self.d[r], smr)
      l = l shr 1;r = r shr 1
    return ST.calc_op(sml, smr)

  proc all_prod*[ST:segtree](self:ST):auto = self.d[1]

  proc getPos[ST:segtree](self: ST, k:int, base:int):Slice[int] =
    static: assert ST.hasP
    let
      h = fastLog2(k)
      l = self.size shr h
      base_n = (k - (1 shl h)) * l - base
    return base_n..<base_n + l

  proc apply*[ST:segtree](self: var ST, p:int, f:ST.F) =
    assert p in 0..<self.n
    let p = p + self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1): self.push(p shr i)
    self.d[p] = ST.calc_mapping(when ST.hasP: self.p(f, self.getPos(p, p - self.size)) else: f, self.d[p])
    when ST.hasData:
      for i in 1..self.log: self.update(p shr i)
  proc apply*[ST:segtree](self: var ST, p:Slice[int], f:ST.F) =
    var (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    if l == r: return

    l += self.size
    r += self.size

    when ST.hasLazy:
      for i in countdown(self.log, 1):
        if ((l shr i) shl i) != l: self.push(l shr i)
        if ((r shr i) shl i) != r: self.push((r - 1) shr i)
      block:
        var (l, r) = (l, r)
        while l < r:
          if (l and 1) != 0: self.all_apply(l, when ST.hasP: self.p(f, self.getPos(l, p.a)) else: f);l.inc
          if (r and 1) != 0: r.dec;self.all_apply(r, when ST.hasP: self.p(f, self.getPos(r, p.a)) else: f)
          l = l shr 1; r = r shr 1

    when ST.hasData:
      for i in 1..self.log:
        if ((l shr i) shl i) != l: self.update(l shr i)
        if ((r shr i) shl i) != r: self.update((r - 1) shr i)

#  template <bool (*g)(S)> int max_right(int l) {
#    return max_right(l, [](S x) { return g(x); });
#  }
  proc max_right*[ST:segtree](self:var ST, l:int, g:(ST.S)->bool):int =
    static: assert ST.hasData
    assert l in 0..self.n
    assert g(ST.calc_e())
    if l == self.n: return self.n
    var l = l + self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1): self.push(l shr i)
    var sm = ST.calc_e()
    while true:
      while l mod 2 == 0: l = l shr 1
      if not g(ST.calc_op(sm, self.d[l])):
        while l < self.size:
          when ST.hasLazy:
            self.push(l)
          l = (2 * l)
          if g(ST.calc_op(sm, self.d[l])):
            sm = ST.calc_op(sm, self.d[l])
            l.inc
        return l - self.size
      sm = ST.calc_op(sm, self.d[l])
      l.inc
      if not((l and -l) != l): break
    return self.n

#  template <bool (*g)(S)> int min_left(int r) {
#    return min_left(r, [](S x) { return g(x); });
#  }
  proc min_left*[ST:segtree](self: var ST, r:int, g:(ST.S)->bool):int =
    static: assert ST.hasData
    assert r in 0..self.n
    assert g(ST.calc_e())
    if r == 0: return 0
    var r = r + self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1): self.push((r - 1) shr i)
    var sm = ST.calc_e()
    while true:
      r.dec
      while r > 1 and r mod 2 == 1: r = r shr 1
      if not g(ST.calc_op(self.d[r], sm)):
        while r < self.size:
          when ST.hasLazy:
            self.push(r)
          r = (2 * r + 1)
          if g(ST.calc_op(self.d[r], sm)):
            sm = ST.calc_op(self.d[r], sm)
            r.dec
        return r + 1 - self.size
      sm = ST.calc_op(self.d[r], sm)
      if not ((r and -r) != r): break
    return 0

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
