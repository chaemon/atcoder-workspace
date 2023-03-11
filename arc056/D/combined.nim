when not declared ATCODER_HEADER_HPP:
  {.hints:off checks:off assertions:on checks:off optimization:speed.}
  const ATCODER_HEADER_HPP = 1
  import std/algorithm
  import std/sequtils
  import std/tables
  import std/macros
  import std/math
  import std/sets
  import std/strutils
  import std/streams
  import std/strformat
  import std/sugar
  
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
  discard
when not declared ATCODER_LAZYSEGTREE_HPP:
  const ATCODER_LAZYSEGTREE_HPP* = 1
  
  import std/sugar
  import std/sequtils
  when not declared ATCODER_INTERNAL_BITOP_HPP:
    const ATCODER_INTERNAL_BITOP_HPP* = 1
    import std/bitops
  
  #ifdef _MSC_VER
  #include <intrin.h>
  #endif
  
  # @param n `0 <= n`
  # @return minimum non-negative `x` s.t. `n <= 2**x`
    proc ceil_pow2*(n:int):int =
      var x = 0
      while (1'u shl x) < n.uint: x.inc
      return x
  # @param n `1 <= n`
  # @return minimum non-negative `x` s.t. `(n & (1 << x)) != 0`
    proc bsf*(n:uint):int =
      return countTrailingZeroBits(n)
    discard
  type lazy_segtree*[S,F] = object
    n, size, log:int
    d:seq[S]
    lz:seq[F]
    op:(S, S)->S
    e:()->S
    mapping:(F,S)->S
    composition:(F,F)->F
    id:()->F
  
  proc update*[ST:lazy_segtree](self:var ST, k:int) = self.d[k] = self.op(self.d[2 * k], self.d[2 * k + 1])
  proc all_apply*[ST:lazy_segtree](self:var ST, k:int, f:ST.F) =
    self.d[k] = self.mapping(f, self.d[k])
    if k < self.size: self.lz[k] = self.composition(f, self.lz[k])
  proc push*[ST:lazy_segtree](self: var ST, k:int) =
    self.all_apply(2 * k, self.lz[k])
    self.all_apply(2 * k + 1, self.lz[k])
    self.lz[k] = self.id()

#  lazy_segtree(int n) : lazy_segtree(std::vector<S>(n, e())) {}
  proc init_lazy_segtree*[S, F](v:int or seq[S], op:(S,S)->S,e:()->S,mapping:(F,S)->S,composition:(F,F)->F,id:()->F):auto =
    when v is int:
      return init_lazy_segtree(newSeqWith(v, e()),op,e,mapping,composition,id)
    else:
      let
        n = v.len
        log = ceil_pow2(n)
        size = 1 shl log
      var d = newSeqWith(2 * size, e())
      for i in 0..<n:
        d[size + i] = v[i]
      result = lazy_segtree[S,F](n:n,log:log,size:size,d:d,lz:newSeqWith(size, id()),op:op,e:e,mapping:mapping,composition:composition,id:id)
      for i in countdown(size - 1, 1):
        result.update(i)

  proc set*[ST:lazy_segtree](self: var ST, p:int, x:ST.S) =
    assert p in 0..<self.n
    let p = p + self.size
    for i in countdown(self.log, 1): self.push(p shr i)
    self.d[p] = x
    for i in 1..self.log: self.update(p shr i)

  proc get*[ST:lazy_segtree](self: ST, p:int):ST.S =
    assert p in 0..<self.n
    let p = p + self.size
    for i in countdown(self.log, 1): self.push(p shr i)
    return self.d[p]

  proc prod*[ST:lazy_segtree](self:var ST, p:Slice[int]):ST.S =
    var (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    if l == r: return self.e()

    l += self.size
    r += self.size

    for i in countdown(self.log, 1):
      if ((l shr i) shl i) != l: self.push(l shr i)
      if ((r shr i) shl i) != r: self.push(r shr i)

    var sml, smr = self.e()
    while l < r:
      if (l and 1) != 0: sml = self.op(sml, self.d[l]);l.inc
      if (r and 1) != 0: r.dec;smr = self.op(self.d[r], smr)
      l = l shr 1
      r = r shr 1
    return self.op(sml, smr)

  proc all_prod*[ST:lazy_segtree](self:ST):auto = self.d[1]

  proc apply*[ST:lazy_segtree](self: var ST, p:int, f:ST.F) =
    assert p in 0..<self.n
    let p = p + self.size
    for i in countdown(self.log, 1): self.push(p shr i)
    self.d[p] = self.mapping(f, self.d[p])
    for i in 1..self.log: self.update(p shr i)
  proc apply*[ST:lazy_segtree](self: var ST, p:Slice[int], f:ST.F) =
    var (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    if l == r: return

    l += self.size
    r += self.size

    for i in countdown(self.log, 1):
      if ((l shr i) shl i) != l: self.push(l shr i)
      if ((r shr i) shl i) != r: self.push((r - 1) shr i)

    block:
      var (l, r) = (l, r)
      while l < r:
        if (l and 1) != 0: self.all_apply(l, f);l.inc
        if (r and 1) != 0: r.dec;self.all_apply(r, f)
        l = l shr 1
        r = r shr 1

    for i in 1..self.log:
      if ((l shr i) shl i) != l: self.update(l shr i)
      if ((r shr i) shl i) != r: self.update((r - 1) shr i)

#  template <bool (*g)(S)> int max_right(int l) {
#    return max_right(l, [](S x) { return g(x); });
#  }
  proc max_right*[ST:lazysegtree](self:var ST, l:int, g:(ST.S)->bool):int =
    assert l in 0..self.n
    assert g(e())
    if l == self.n: return self.n
    var l = l + self.size
    for i in countdown(self.log, 1): self.push(l shr i)
    var sm = self.e()
    while true:
      while l mod 2 == 0: l = l shr 1
      if not g(self.op(sm, self.d[l])):
        while l < self.size:
          self.push(l)
          l = (2 * l)
          if g(self.op(sm, self.d[l])):
            sm = self.op(sm, self.d[l])
            l.inc
        return l - self.size
      sm = self.op(sm, self.d[l])
      l.inc
      if not((l & -l) != l): break
    return self.n

#  template <bool (*g)(S)> int min_left(int r) {
#    return min_left(r, [](S x) { return g(x); });
#  }
  proc min_left*[ST:lazy_segtree](self: var ST, r:int, g:(ST.S)->bool):int =
    assert r in 0..self.n
    assert(g(self.e()))
    if r == 0: return 0
    var r = r + self.size
    for i in countdown(self.log, 1): self.push((r - 1) shr i)
    var sm = self.e()
    while true:
      r.dec
      while r > 1 and r mod 2 == 1: r = r shr 1
      if not g(self.op(self.d[r], sm)):
        while r < self.size:
          self.push(r)
          r = (2 * r + 1)
          if g(self.op(self.d[r], sm)):
            sm = self.op(self.d[r], sm)
            r.dec
        return r + 1 - self.size
      sm = self.op(self.d[r], sm)
      if not ((r & -r) != r): break
    return 0
  discard

let
  N = nextInt()
  w = newSeqWith(N, nextInt())

type D = int
type L = int

proc f(a, b:D):D = max(a, b)
proc g(d:D, l:L):D = d + l
proc h(a, b:L):L = a + b
proc op():D = -int.inf
proc id():L = 0


var
  t = newSeqWith(N, newSeq[int]())
  v = newSeq[int]()

for i in 0..<N:
  let M = nextInt()
  t[i] = newSeqWith(M, nextInt())
  v.add(t[i])

v = v.toHashSet.toSeq.sorted


var e = newSeq[seq[int]](v.len)

for i in 0..<N:
  for t in t[i].mitems:
    t = v.binarySearch(t)
    e[t].add(i)

var
  prev = newSeqWith(N, -1)
  st = init_lazy_segtree(v.len + 1, f, op, g, h, id)

var ans = 0

st.set(0, 0)

for t in 0..<v.len:
  let u = st.all_prod()
  ans.max=u
  st.set(t + 1, u)
  for i in e[t]:
    st.apply(prev[i] + 1..t + 1, w[i])
    prev[i] = t + 1

ans.max=st.all_prod
echo ans
