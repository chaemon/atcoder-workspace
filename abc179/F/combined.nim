# {{{ header
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm
  import std/sequtils
  import std/tables
  import std/macros
  import std/math
  import std/sets
  import std/strutils
  import std/strformat
  import std/sugar
  
  import streams
  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  #proc getchar(): char {.header: "<stdio.h>", varargs.}
  proc nextInt*(): int = scanf("%lld",addr result)
  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*[F](f:F): string =
    var get = false
    result = ""
    while true:
  #    let c = getchar()
      let c = f.readChar
      if c.int > ' '.int:
        get = true
        result.add(c)
      elif get: return
  proc nextInt*[F](f:F): int = parseInt(f.nextString)
  proc nextFloat*[F](f:F): float = parseFloat(f.nextString)
  proc nextString*():string = stdin.nextString()
  
  template `max=`*(x,y:typed):void = x = max(x,y)
  template `min=`*(x,y:typed):void = x = min(x,y)
  template inf*(T): untyped = 
    when T is SomeFloat: T(Inf)
    elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
    else: assert(false)
  
  proc discardableId*[T](x: T): T {.discardable.} =
    return x
  
  macro `:=`*(x, y: untyped): untyped =
    var strBody = ""
    if x.kind == nnkPar:
      for i,xi in x:
        strBody &= fmt"""
{xi.repr} := {y[i].repr}
"""
    else:
      strBody &= fmt"""
when declaredInScope({x.repr}):
  {x.repr} = {y.repr}
else:
  var {x.repr} = {y.repr}
"""
    strBody &= fmt"discardableId({x.repr})"
    parseStmt(strBody)
  
  
  proc toStr*[T](v:T):string =
    proc `$`[T](v:seq[T]):string =
      v.mapIt($it).join(" ")
    return $v
  
  proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =
    result = ""
    for i,v in x:
      if i != 0: addSep(result, sep = sep)
      add(result, v)
    result.add("\n")
    stdout.write result
  
  var print*:proc(x: varargs[string, toStr])
  print = proc(x: varargs[string, toStr]) =
    discard print0(@x, sep = " ")
  
  template makeSeq*(x:int; init):auto =
    when init is typedesc: newSeq[init](x)
    else: newSeqWith(x, init)
  
  macro Seq*(lens: varargs[int]; init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0): a = fmt"makeSeq({lens[i].repr}, {a})"
    parseStmt(fmt"""  
block:
  {a}""")
  
  template makeArray*(x:int; init):auto =
    var v:array[x, init.type]
    when init isnot typedesc:
      for a in v.mitems: a = init
    v
  
  macro Array*(lens: varargs[typed], init):untyped =
    var a = fmt"{init.repr}"
    for i in countdown(lens.len - 1, 0):
      a = fmt"makeArray({lens[i].repr}, {a})"
    parseStmt(fmt"""
block:
  {a}""")
# }}}
  discard
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
    proc ceil_pow2*(n:int):int =
      var x = 0
      while (1'u shl x) < n.uint: x.inc
      return x
  # @param n `1 <= n`
  # @return minimum non-negative `x` s.t. `(n & (1 << x)) != 0`
    proc bsf*(n:uint):int =
      return countTrailingZeroBits(n)
    discard
  type segtree[S,F,useP] = object
    n, size, log:int
    when S isnot void:
      d:seq[S]
      op:(S, S)->S
      e:()->S
    when F isnot void:
      lz:seq[F]
      composition:(F,F)->F
      id:()->F
      when S isnot void:
        mapping:(F,S)->S
      when useP isnot void:
        p:(F,Slice[int])->F
  proc hasData(ST:typedesc[segtree]):bool {.compileTime.} = ST.S isnot void
  proc hasLazy(ST:typedesc[segtree]):bool {.compileTime.} = ST.F isnot void
  proc hasP(ST:typedesc[segtree]):bool {.compileTime.} = ST.useP isnot void
  
  proc update*[ST:segtree](self:var ST, k:int) =
    self.d[k] = self.op(self.d[2 * k], self.d[2 * k + 1])
  proc all_apply*[ST:segtree](self:var ST, k:int, f:ST.F) =
    static: assert ST.hasLazy
    when ST.hasData:
      self.d[k] = self.mapping(f, self.d[k])
      if k < self.size: self.lz[k] = self.composition(f, self.lz[k])
    else:
      self.lz[k] = self.composition(f, self.lz[k])

  proc push*[ST:segtree](self: var ST, k:int) =
    static: assert ST.hasLazy
    when ST.hasP:
      let m = self.size shr (k.fastLog2 + 1)
    self.all_apply(2 * k    , when ST.hasP: self.p(self.lz[k], 0..<m    ) else: self.lz[k])
    self.all_apply(2 * k + 1, when ST.hasP: self.p(self.lz[k], m..<m + m) else: self.lz[k])
    self.lz[k] = self.id()

#  segtree(int n) : segtree(std::vector<S>(n, e())) {}
  proc init*[ST:segtree](self: var ST, v:int or seq[ST.S] or seq[ST.F]) =
    when v is int:
      when ST.hasData:
        self.init(newSeqWith(v, self.e()))
      else:
        self.init(newSeqWith(v, self.id()))
    else:
      let
        n = v.len
        log = ceil_pow2(n)
        size = 1 shl log
      self.n = n;self.log = log;self.size = size
      when ST.hasLazy:
        when ST.hasData:
          self.lz = newSeqWith(size, self.id())
        else:
          self.lz = newSeqWith(size * 2, self.id())
      when ST.hasData:
        self.d = newSeqWith(2 * size, self.e())
        for i in 0..<n: self.d[size + i] = v[i]
        for i in countdown(size - 1, 1): self.update(i)
      else:
        for i in 0..<n: self.lz[size + i] = v[i]

  proc init_segtree*[S](v:seq[S], op:(S,S)->S, e:()->S):auto =
    result = segtree[S,void,void](op:op,e:e)
    result.init(v)
  proc init_segtree*[S](n:int, op:(S,S)->S, e:()->S):auto =
    init_segtree*[S](newSeqWith(n, e()), op, e)
  proc init_dual_segtree*[F](v:seq[F], composition:(F,F)->F, id:()->F):auto =
    result = segtree[void,F,void](composition:composition,id:id)
    result.init(v)
  proc init_dual_segtree*[F](n:int, composition:(F,F)->F, id:()->F):auto =
    init_dual_segtree*[F](newSeqWith(n, id()), composition, id)
  proc init_lazy_segtree*[S,F](v:seq[S], op:(S,S)->S,e:()->S,mapping:(F,S)->S,composition:(F,F)->F,id:()->F):auto =
    result = segtree[S,F,void](op:op,e:e,mapping:mapping,composition:composition,id:id)
    result.init(v)
  proc init_lazy_segtree*[S,F](n:int, op:(S,S)->S,e:()->S,mapping:(F,S)->S,composition:(F,F)->F,id:()->F):auto =
    init_lazy_segtree*[S,F](newSeqWith(n, e()), op,e,mapping,composition,id)
  proc init_lazy_segtree*[S,F](v:seq[S], op:(S,S)->S,e:()->S,mapping:(F,S)->S,composition:(F,F)->F,id:()->F, p:(F,Slice[int])->F):auto =
    result = segtree[S,F,int](op:op,e:e,mapping:mapping,composition:composition,id:id, p:p)
    result.init(v)
  proc init_lazy_segtree*[S,F](n:int, op:(S,S)->S,e:()->S,mapping:(F,S)->S,composition:(F,F)->F,id:()->F, p:(F,Slice[int])->F):auto =
    init_lazy_segtree*[S,F](newSeqWith(n, e()), op,e,mapping,composition,id,p)

  proc set*[ST:segtree](self: var ST, p:int, x:ST.S or ST.F) =
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
    if l == r: return self.e()
    l += self.size;r += self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1):
        if ((l shr i) shl i) != l: self.push(l shr i)
        if ((r shr i) shl i) != r: self.push(r shr i)
    var sml, smr = self.e()
    while l < r:
      if (l and 1) != 0: sml = self.op(sml, self.d[l]);l.inc
      if (r and 1) != 0: r.dec;smr = self.op(self.d[r], smr)
      l = l shr 1;r = r shr 1
    return self.op(sml, smr)

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
    self.d[p] = self.mapping(when ST.hasP: self.p(f, self.getPos(p, p - self.size)) else: f, self.d[p])
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
    assert g(e())
    if l == self.n: return self.n
    var l = l + self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1): self.push(l shr i)
    var sm = self.e()
    while true:
      while l mod 2 == 0: l = l shr 1
      if not g(self.op(sm, self.d[l])):
        while l < self.size:
          when ST.hasLazy:
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
  proc min_left*[ST:segtree](self: var ST, r:int, g:(ST.S)->bool):int =
    static: assert ST.hasData
    assert r in 0..self.n
    assert g(self.e())
    if r == 0: return 0
    var r = r + self.size
    when ST.hasLazy:
      for i in countdown(self.log, 1): self.push((r - 1) shr i)
    var sm = self.e()
    while true:
      r.dec
      while r > 1 and r mod 2 == 1: r = r shr 1
      if not g(self.op(self.d[r], sm)):
        while r < self.size:
          when ST.hasLazy:
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
#import atcoder/lazysegtree


import algorithm

let N, Q = nextInt()
var t, x = newSeq[int](Q)
for i in 0..<Q:
  t[i] = nextInt()
  x[i] = nextInt() - 2

#proc naive() =
#  var xs, ys = newSeq[int]()
#  for q in 0..<Q:
#    if t[q] == 1:
#      ys.add(x[q])
#    else:
#      xs.add(x[q])
#  xs = xs.toSeq().mapIt(it).sorted
#  ys = ys.toSeq().mapIt(it).sorted
#  xs.add(N - 2)
#  ys.add(N - 2)
#  var a = Seq(xs.len, ys.len, false)
#  for i in 0..<a.len:
#    a[i][^1] = true
#  for i in 0..<a[0].len:
#    a[^1][i] = true
#  var ans = 0
#  for q in 0..<Q:
#    if t[q] == 1:
#      let y = ys.binarySearch(x[q])
#      for i in 0..<a.len:
#        if a[i][y]:
#          dump(xs[i])
#          ans += xs[i]
#          break
#        a[i][y] = true
#
#    else:
#      let x = xs.binarySearch(x[q])
#      for i in 0..<a[x].len:
#        if a[x][i]:
#          dump(ys[i])
#          ans += ys[i]
#          break
#        a[x][i] = true
#  echo (N - 2)^2 - ans
#
#naive()

proc main() =
#  var st0, st1 = initlazySegTree(N, (a:int,b:int)=>min(a,b), ()=>int.inf, (a:int, b:int)=>min(a, b), (a:int,b:int)=>min(a,b), ()=>int.inf)
  var st0 = initDualSegTree(newSeqWith(N - 2, N - 2), (a:int,b:int)=>min(a,b), ()=>int.inf)
  var st1 = initDualSegTree(newSeqWith(N - 2, N - 2), (a:int,b:int)=>min(a,b), ()=>int.inf)
  var a, b = N - 2
  var ans = (N - 2)^2
  for q in 0..<Q:
    if t[q] == 1:
      if x[q] < b:
        b = x[q]
        ans -= a
        st0.apply(0..<a, b)
      elif x[q] > b:
        let t = st1.get(x[q])
        ans -= t
      else:
        assert false
    else:
      if x[q] < a:
        a = x[q]
        ans -= b
        st1.apply(0..<b, a)
      elif x[q] > a:
        let t = st0.get(x[q])
        ans -= t
      else:
        assert false
  echo ans
  return

main()

