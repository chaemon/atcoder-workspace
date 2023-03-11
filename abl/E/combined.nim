# ========= utils/base.nim ========= {{{

when not declared(INCLUDE_GUARD_UTILS_BASE_NIM):
  const INCLUDE_GUARD_UTILS_BASE_NIM = 1
  import macros
  macro Please(x): untyped = nnkStmtList.newTree()

  Please give me AC
  Please give me AC
  Please give me AC

  {.hints: off, overflowChecks: on.}
 # {.hints: off, checks:off.}

  import strutils
  import sequtils
  import math
  import algorithm
  when (not (NimMajor <= 0)) or NimMinor >= 19:
    import sugar
  else:
    import future

  iterator range(x, y: int): int {.inline.} =
    var res = x
    while res < y:
      yield res
      inc(res)
  iterator range(x: int): int {.inline.} =
    var res = 0
    while res < x:
      yield res
      inc(res)
  proc range(x, y: int): seq[int] {.inline.} =
    toSeq(x..y-1)
  proc range(x: int): seq[int] {.inline.} =
    toSeq(0..x-1)
  proc discardableId[T](x: T): T {.inline, discardable.} =
    return x
  macro `:=`(x, y: untyped): untyped =
    if (x.kind == nnkIdent):
      return quote do:
        when declaredInScope(`x`):
          `x` = `y`
        else:
          var `x` = `y`
        discardableId(`x`)
    else:
      return quote do:
        `x` = `y`
        discardableId(`x`)
  when NimMajor <= 0 and NimMinor <= 17:
    proc count[T](co: openArray[T]; obj: T): int =
      for itm in items(co):
        if itm == obj:
          inc result
  proc divmod(x, y: SomeInteger): (int, int) =
    (x div y, x mod y)
  proc `min=`[T](x: var T; y: T): bool {.discardable.} =
    if x > y:
      x = y
      return true
    else:
      return false
  proc `max=`[T](x: var T; y: T): bool {.discardable.} =
    if x < y:
      x = y
      return true
    else:
      return false

  when NimMajor <= 0 and NimMinor <= 17:
    iterator pairs(n: NimNode): (int, NimNode) {.inline.} =
      for i in 0 ..< n.len:
        yield (i, n[i])

  #[
  when NimMajor <= 0 and NimMinor <= 18:
    macro parseInnerType(x: NimNode): untyped =
      newIdentNode("parse" & x[1][1].repr)
  else:
    macro parseInnerType(x: typedesc): untyped =
      newIdentNode("parse" & x.getType[1][1].repr)
  ]#

  proc parseInnerType(x: NimNode): NimNode =
    newIdentNode("parse" & x[1].repr)

  proc inputAsTuple(ty: NimNode): NimNode =
    result = nnkStmtListExpr.newTree()
    t := genSym()
    result.add quote do: (let `t` = stdin.readLine.split)
    p := nnkPar.newTree()
    for i, typ_tmp in ty.pairs:
      var ece, typ: NimNode
      if typ_tmp.kind == nnkExprColonExpr:
        ece = nnkExprColonExpr.newTree(typ_tmp[0])
        typ = typ_tmp[1]
      else:
        ece = nnkExprColonExpr.newTree(ident("f" & $i))
        typ = typ_tmp
      if typ.repr == "string":
        ece.add quote do: `t`[`i`]
      else:
        parsefn := newIdentNode("parse" & typ.repr)
        ece.add quote do: `t`[`i`].`parsefn`
      p.add ece
    result.add p

  macro inputAsType(ty: untyped): untyped =
    if ty.kind == nnkBracketExpr:
      if ty[1].repr == "string":
        return quote do: stdin.readLine.split
      else:
        parsefn := parseInnerType(ty)
        return quote do: stdin.readLine.split.map(`parsefn`)
        #[
          when NimMajor <= 0 and NimMinor <= 18:
            stdin.readLine.split.map(parseInnerType(ty.getType))
          else:
            stdin.readLine.split.map(parseInnerType(ty))
        ]#
    elif ty.kind == nnkPar:
      return inputAsTuple(ty)
    elif ty.repr == "string":
      return quote do: stdin.readLine
    else:
      parsefn := ident("parse" & ty.repr)
      return quote do: stdin.readLine.`parsefn`

  macro input(query: untyped): untyped =
    doAssert query.kind == nnkStmtList
    result = nnkStmtList.newTree()
    letSect := nnkLetSection.newTree()
    for defs in query:
      if defs[0].kind == nnkIdent:
        tmp := nnkIdentDefs.newTree(defs[0], newEmptyNode())
        typ := defs[1][0]
        var val: NimNode
        if typ.len <= 2:
          val = quote do: inputAsType(`typ`)
        else:
          op := typ[2]
          typ.del(2, 1)
          val = quote do: inputAsType(`typ`).mapIt(`op`)
        if defs[1].len > 1:
          op := defs[1][1]
          it := ident"it"
          tmp.add quote do:
            block:
              var `it` = `val`
              `op`
        else:
          tmp.add val
        letSect.add tmp
      elif defs[0].kind == nnkPar:
        vt := nnkVarTuple.newTree()
        for id in defs[0]:
          vt.add id
        vt.add newEmptyNode()
        sle := nnkStmtListExpr.newTree()
        t := genSym()
        sle.add quote do: (let `t` = stdin.readLine.split)
        p := nnkPar.newTree()
        if defs[1][0].kind == nnkPar:
          for i, typ in defs[1][0].pairs:
            if typ.repr == "string":
              p.add quote do: `t`[`i`]
            else:
              parsefn := newIdentNode("parse" & typ.repr)
              p.add quote do: `t`[`i`].`parsefn`
        else:
          typ := defs[1][0]
          if typ.repr == "string":
            for i in 0..<defs[0].len:
              p.add quote do: `t`[`i`]
          else:
            parsefn := newIdentNode("parse" & typ.repr)
            for i in 0..<defs[0].len:
              p.add quote do: `t`[`i`].`parsefn`
        sle.add p
        vt.add sle
        letSect.add vt
      elif defs[0].kind == nnkBracketExpr:
        ids := nnkIdentDefs.newTree(defs[0][0], newEmptyNode())
        cnt := defs[0][1]
        typ := defs[1][0]
        var input: NimNode
        if typ.kind == nnkBracketExpr and typ.len > 2:
          op := typ[2]
          typ.del(2, 1)
          input = quote do: inputAsType(`typ`).mapIt(`op`)
        else:
          input = quote do: inputAsType(`typ`)
        var val: NimNode
        if defs[0].len > 2:
          op := defs[0][2]
          it := ident"it"
          val = quote do:
            block:
              var `it` = `input`
              `op`
        else:
          val = input
        if defs[1].len > 1:
          op := defs[1][1]
          it := ident"it"
          ids.add(quote do:
            block:
              var `it` = newSeqWith(`cnt`, `val`)
              `op`)
        else:
          ids.add(quote do: newSeqWith(`cnt`, `val`))
        letSect.add ids
    result.add letSect

  proc makeSeq[T, Idx](num: array[Idx, int]; init: T): auto =
    when num.len == 1:
      return newSeqWith(num[0], init)
    else:
      var tmp: array[num.len-1, int]
      for i, t in tmp.mpairs: t = num[i+1]
      return newSeqWith(num[0], makeSeq(tmp, init))

  proc parseInt1(str: string): int =
    str.parseInt - 1

# ========= utils/base.nim ========= }}}
#
## ========= segt/lazy.nim ========= {{{
#
#when not declared(INCLUDE_GUARD_SEGT_LAZY_NIM):
#  const INCLUDE_GUARD_SEGT_LAZY_NIM = 1
#
#  import sequtils, math, bitops
#
#  when (not (NimMajor <= 0)) or NimMinor >= 19:
#    import sugar
#  else:
#    import future
#
#  type
#    LazySegmentTree[T, O] = ref object
#      n: int
#      node: seq[T]
#      lazy: seq[O]
#      ad: (T, T) -> T
#      op: (T, O) -> T
#      marge: (O, O) -> O
#      zeroT: T
#      zeroO: O
#
#  proc initLazySegT[T, O](data: seq[T];
#                          ad: (T, T) -> T;
#                          op: (T, O) -> T;
#                          marge: (O, O) -> O;
#                          zeroT: T;
#                          zeroO: O): LazySegmentTree[T, O] =
#    let
#      n = data.len.nextPowerOfTwo
#      lazy = newSeqWith(2*n, zeroO)
#    var
#      node = newSeq[T](2*n)
#    for i in 0..<data.len:
#      node[i+n] = data[i]
#    for i in data.len..<n:
#      node[i+n] = zeroT
#    for i in countdown(n-1, 1):
#      node[i] = ad(node[i*2], node[i*2+1])
#    return LazySegmentTree[T, O](
#      n: n,
#      node: node,
#      lazy: lazy,
#      ad: ad,
#      op: op,
#      marge: marge,
#      zeroT: zeroT,
#      zeroO: zeroO
#    )
#
#  proc propagate[T, O](segt: LazySegmentTree[T, O]; i: int) =
#    segt.lazy[2*i] = segt.marge(segt.lazy[2*i], segt.lazy[i])
#    segt.lazy[2*i+1] = segt.marge(segt.lazy[2*i+1], segt.lazy[i])
#    segt.lazy[i] = segt.zeroO
#
#  proc propagateBound[T, O](segt: LazySegmentTree[T, O]; i: int) =
#    if i == 0: return
#    let ctz = countTrailingZeroBits(i)
#    for h in countdown(63 - countLeadingZeroBits(i), ctz+1):
#      segt.propagate(i shr h)
#
#  proc recalc[T, O](segt: LazySegmentTree[T, O]; i: int) =
#    segt.node[i] = segt.ad(segt.op(segt.node[2*i], segt.lazy[2*i]), segt.op(
#        segt.node[2*i+1], segt.lazy[2*i+1]))
#
#  proc recalcBound[T, O](segt: LazySegmentTree[T, O]; i: int) =
#    if i == 0: return
#    var i = i shr countTrailingZeroBits(i)
#    while i > 1:
#      i = i div 2
#      segt.recalc(i)
#
#  proc updateRange[T, O](segt: LazySegmentTree[T, O]; left, right: int; v: O) =
#    var
#      left = left + segt.n
#      right = right + segt.n
#    segt.propagateBound(left)
#    segt.propagateBound(right)
#    let
#      leftOrig = left
#      rightOrig = right
#    while left < right:
#      if left mod 2 == 1:
#        segt.lazy[left] = segt.marge(segt.lazy[left], v)
#        left.inc
#      if right mod 2 == 1:
#        right.dec
#        segt.lazy[right] = segt.marge(segt.lazy[right], v)
#      left = left div 2
#      right = right div 2
#    segt.recalcBound(leftOrig)
#    segt.recalcBound(rightOrig)
#
#  proc updatePoint[T, O](segt: LazySegmentTree[T, O]; x: int; v: T) =
#    var i = segt.n + x
#    for h in countdown(63 - countLeadingZeroBits(i), 1):
#      segt.propagate(i shr h)
#    segt.node[i] = v
#    segt.lazy[i] = segt.zeroO
#    while i > 1:
#      i = i div 2
#      segt.recalc(i)
#
#  proc fold[T, O](segt: LazySegmentTree[T, O]; left, right: int): T =
#    var
#      left = left + segt.n
#      right = right + segt.n
#      accL, accR = segt.zeroT
#    segt.propagateBound(left)
#    segt.recalcBound(left)
#    segt.propagateBound(right)
#    segt.recalcBound(right)
#    while left < right:
#      if left mod 2 == 1:
#        accL = segt.ad(accL, segt.op(segt.node[left], segt.lazy[left]))
#        left.inc
#      if right mod 2 == 1:
#        right.dec
#        accR = segt.ad(segt.op(segt.node[right], segt.lazy[right]), accR)
#      left = left div 2
#      right = right div 2
#    result = segt.ad(accL, accR)
#
#  proc getPoint[T, O](segt: LazySegmentTree[T, O]; i: int): T =
#    let i = segt.n + i
#    for h in countdown(63 - countLeadingZeroBits(i), 1):
#      segt.propagate(i shr h)
#    return segt.op(segt.node[i], segt.lazy[i])
#
## ========= segt/lazy.nim ========= }}}
#
# ========= math/modint.nim ========= {{{

# ========= math/mathMod.nim ========= {{{

when not declared(INCLUDE_GUARD_MATH_MATHMOD_NIM):
  const INCLUDE_GUARD_MATH_MATHMOD_NIM = 1
  proc `mod`(x, y: int): int {.inline.} =
    if x < 0:
      y - system.`mod`(-x, y)
    else:
      system.`mod`(x, y)

# ========= math/mathMod.nim ========= }}}


when not declared(INCLUDE_GUARD_MATH_MODINT_NIM):
  const INCLUDE_GUARD_MATH_MODINT_NIM = 1
  import math
  import sequtils
  import strutils

  proc extgcd(x, y: SomeInteger): (int, int) =
    if x < y:
      let (a, b) = extgcd(y, x)
      return (b, a)
    if y == 0 or x mod y == 0: return (0, 1)
    let (a, b) = extgcd(y, x mod y)
    return (b, -(x div y) * b + a)

  type ModInt[M: static[int]] = object
    v: int

  template initModInt(val: int): auto =
    when declared(MOD):
      ModInt[MOD](v: val mod MOD)
    else:
      ModInt[1000000007](v: val mod 1000000007)

  proc `$`[M](n: ModInt[M]): string {.inline.} =
    $n.v

  proc inv[M](n: ModInt[M]): ModInt[M] {.inline.} =
    result.v = (extgcd(n.v, M)[0]) mod M

  proc modinv(n: int; m: int): int {.inline.} =
    result = (extgcd(n, m)[0]) mod m

  proc `+`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    result.v = (n.v + m.v)
    if result.v >= M: result.v -= M

  proc `+`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    result.v = (n.v + m) mod M

  proc `*`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    result.v = n.v * m.v mod M

  proc `*`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    result.v = n.v * m mod M

  proc `-`[M](n: ModInt[M]): ModInt[M] {.inline.} =
    result.v = M - n.v

  proc `-`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    result.v = (n.v - m) mod M

  proc `-`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    result.v = (n.v - m.v) mod M

  proc `/`[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    n * inv(m)

  proc `/`[M](n: ModInt[M]; m: int): ModInt[M] {.inline.} =
    n / initModInt(m)

  proc `+=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n + m

  proc `-=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n - m

  proc `*=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n * m

  proc `/=`[M](n: var ModInt[M]; m: int|ModInt[M]) {.inline.} =
    n = n / m

  proc fac[M](n: ModInt[M]): ModInt[M] =
    result.v = 1
    for i in 2..n.v:
      result.v = result.v * i mod M

  proc perm[M](n, m: ModInt[M]): ModInt[M] =
    result.v = 1
    for i in n.v-m.v+1..n.v:
      result.v = result.v * i mod M

  proc binom[M](n, m: ModInt[M]): ModInt[M] {.inline.} =
    perm(n, m) / (fac(m))

  proc modfac(n: int; M: static[int]): int =
    result = 1
    for i in 2..n:
      result = result * i mod M

  proc modperm(n, m: int; M: static[int]): int =
    result = 1
    for i in n-m+1..n:
      result = result * i mod M

  proc modbinom(n, m: int; M: static[int]): int {.inline.} =
    modperm(n, m, M) / (modfac(m, M))

  proc garner(args: openArray[(int, int)]; modulo = -1): (int, int) =
    result = (1, 0)
    let n = args.len
    var coe, con = newSeq[int](n)
    for c in coe.mitems:
      c = 1
    for i in 0..<n:
      let t = (args[i][1] - con[i]) * modinv(coe[i], args[i][0]) mod args[i][0]
      for k in i+1 ..< n:
        con[k] = (con[k] + coe[k] * t) mod args[k][0]
        coe[k] = coe[k] * args[i][0] mod args[k][0]
      result[1] = result[1] + result[0] * t
      result[0] = result[0] * args[i][0]
      if modulo > 0:
        result[0] = result[0] mod modulo
        result[1] = result[1] mod modulo
    if modulo > 0: result[0] = modulo

  proc garner(args: openArray[(int, seq[int])]; modulo = -1): (int, seq[int]) =
    let P = args[0][1].len
    result = (1, newSeq[int](P))
    let n = args.len
    var
      coe = newSeq[int](n)
      con = newSeqWith(n, newSeq[int](P))
    for c in coe.mitems:
      c = 1
    for i in 0..<n:
      for p in 0..<P:
        let t = (args[i][1][p] - con[i][p]) * modinv(coe[i], args[i][
            0]) mod args[i][0]
        for k in i+1 ..< n:
          con[k][p] = (con[k][p] + coe[k] * t mod args[k][0]) mod args[k][0]
        if modulo > 0:
          result[1][p] = (result[1][p] + result[0] * t mod modulo) mod modulo
        else:
          result[1][p] = (result[1][p] + result[0] * t)
      for k in i+1 ..< n:
        coe[k] = coe[k] * args[i][0] mod args[k][0]
      result[0] = result[0] * args[i][0] mod modulo
      if modulo > 0:
        result[0] = result[0] mod modulo
    if modulo > 0: result[0] = modulo

  proc modpow(n, p, m: int): int =
    var
      p = p
      t = n
    result = 1
    while p > 0:
      if (p and 1) == 1:
        result = result * t mod m
      t = t * t mod m
      p = p shr 1

  template parseModInt(x: string): ModInt =
    initModInt(x.parseInt)

# ========= math/modint.nim ========= }}}

import options
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
  type LazySegtree*[S,F;p:static[tuple]] = object
    n*, size*, log*:int
    d:seq[S]
    lz:seq[F]
#    op:(S, S)->S
#    e:()->S
#    mapping:(F,S)->S
#    composition:(F,F)->F
#    id:()->F
  
  proc update[ST:LazySegtree](self:var ST, k:int) =
    let op = ST.p.op
    self.d[k] = op(self.d[2 * k], self.d[2 * k + 1])
  proc all_apply*[ST:LazySegtree](self:var ST, k:int, f:ST.F) =
    let mapping = ST.p.mapping
    self.d[k] = mapping(f, self.d[k])
    let composition = ST.p.composition
    if k < self.size: self.lz[k] = composition(f, self.lz[k])
  proc push*[ST:LazySegtree](self: var ST, k:int) =
    self.all_apply(2 * k, self.lz[k])
    self.all_apply(2 * k + 1, self.lz[k])
    let id = ST.p.id
    self.lz[k] = id()

  proc init[ST:LazySegtree](self:var ST, v:seq[ST.S]) =
    let
      n = v.len
      log = ceil_pow2(n)
      size = 1 shl log
    let e = ST.p.e
    var d = newSeqWith(2 * size, e())
    for i in 0..<n:
      d[size + i] = v[i]
    let id = ST.p.id
    self = ST(n:n,log:log,size:size,d:d,lz:newSeqWith(size, id()))
    for i in countdown(size - 1, 1):
      self.update(i)
  proc init[ST:LazySegtree](self: var ST, n:int) =
    let e = ST.p.e
    self.init(newSeqWith(n, e()))
  proc init[ST:LazySegtree](self: typedesc[ST], v:seq[ST.S]):auto =
    result = ST()
    result.init(v)
  proc init[ST:LazySegtree](self: typedesc[ST], n:int):auto =
    result = ST()
    result.init(n)

#  LazySegtree(int n) : LazySegtree(std::vector<S>(n, e())) {}
  proc init_LazySegtree*[S, F](v:seq[S], op:static[(S,S)->S],e:static[()->S],mapping:static[(F,S)->S],composition:static[(F,F)->F],id:static[()->F]):auto =
    type ST = LazySegtree[S,F,(op:op,e:e,mapping:mapping, composition:composition, id:id)]
    return ST.init(v)
  proc init_LazySegtree*[S, F](n:int, op:static[(S,S)->S],e:static[()->S],mapping:static[(F,S)->S],composition:static[(F,F)->F],id:static[()->F]):auto =
    type ST = LazySegtree[S,F,(op:op,e:e,mapping:mapping, composition:composition, id:id)]
    let e = e
    return ST.init(newSeqWith(n, e()))


  proc set*[ST:LazySegtree](self: var ST, p:int, x:ST.S) =
    assert p in 0..<self.n
    let p = p + self.size
    for i in countdown(self.log, 1): self.push(p shr i)
    self.d[p] = x
    for i in 1..self.log: self.update(p shr i)

  proc get*[ST:LazySegtree](self: var ST, p:int):ST.S =
    assert p in 0..<self.n
    let p = p + self.size
    for i in countdown(self.log, 1): self.push(p shr i)
    return self.d[p]

  proc prod*[ST:LazySegtree](self:var ST, p:Slice[int]):ST.S =
    var (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    let e = ST.p.e
    if l == r: return e()

    l += self.size
    r += self.size

    for i in countdown(self.log, 1):
      if ((l shr i) shl i) != l: self.push(l shr i)
      if ((r shr i) shl i) != r: self.push(r shr i)

    var sml, smr = e()
    while l < r:
      let op = ST.p.op
      if (l and 1) != 0: sml = op(sml, self.d[l]);l.inc
      if (r and 1) != 0: r.dec;smr = op(self.d[r], smr)
      l = l shr 1
      r = r shr 1
    let op = ST.p.op
    return op(sml, smr)

  proc all_prod*[ST:LazySegtree](self:ST):auto = self.d[1]

  proc apply*[ST:LazySegtree](self: var ST, p:int, f:ST.F) =
    assert p in 0..<self.n
    let p = p + self.size
    for i in countdown(self.log, 1): self.push(p shr i)
    let mapping = ST.p.mapping
    self.d[p] = mapping(f, self.d[p])
    for i in 1..self.log: self.update(p shr i)
  proc apply*[ST:LazySegtree](self: var ST, p:Slice[int], f:ST.F) =
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
  proc max_right*[ST:LazySegtree](self:var ST, l:int, g:(ST.S)->bool):int =
    assert l in 0..self.n
    let e = ST.p.e
    assert g(e())
    if l == self.n: return self.n
    var l = l + self.size
    for i in countdown(self.log, 1): self.push(l shr i)
    var sm = e()
    while true:
      while l mod 2 == 0: l = l shr 1
      let op = ST.p.op
      if not g(op(sm, self.d[l])):
        while l < self.size:
          self.push(l)
          l = (2 * l)
          let op = ST.p.op
          if g(op(sm, self.d[l])):
            let op = ST.p.op
            sm = op(sm, self.d[l])
            l.inc
        return l - self.size
      sm = op(sm, self.d[l])
      l.inc
      if not((l and -l) != l): break
    return self.n

#  template <bool (*g)(S)> int min_left(int r) {
#    return min_left(r, [](S x) { return g(x); });
#  }
  proc min_left*[ST:LazySegtree](self: var ST, r:int, g:(ST.S)->bool):int =
    assert r in 0..self.n
    let e = ST.p.e
    assert(g(e()))
    if r == 0: return 0
    var r = r + self.size
    for i in countdown(self.log, 1): self.push((r - 1) shr i)
    var sm = e()
    while true:
      r.dec
      while r > 1 and r mod 2 == 1: r = r shr 1
      let op = ST.p.op
      if not g(op(self.d[r], sm)):
        while r < self.size:
          self.push(r)
          r = (2 * r + 1)
          let op = ST.p.op
          if g(op(self.d[r], sm)):
            let op = ST.p.op
            sm = op(self.d[r], sm)
            r.dec
        return r + 1 - self.size
      sm = op(self.d[r], sm)
      if not ((r and -r) != r): break
    return 0

input:
  (N, Q): int

const MOD = 998244353

type
  A = Option[(int, int)]
  B = Option[int]

var
  snuke = newSeqWith(N+1, 1)

proc op(x, y: A): A =
  if x.isNone:
    return y
  elif y.isNone:
    return x
  else:
    return option(((x.get[0] * snuke[y.get[1]] + y.get[0]) mod MOD,
        x.get[1] + y.get[1]))


for i in range(N):
  snuke[i+1] = snuke[i] * 10 mod MOD

var
  nanachi = newSeqWith(10, newSeqWith(N+1, 0))
  segt = initLazysegtree(
    newSeqWith(N + 1, option((1, 1))),
    op,
    () => none[(int, int)](),
    (y: B, x: A) => (if x.isSome: option(((if y.isSome: nanachi[y.get][x.get[
        1]] else: x.get[0]), x.get[1])) else: x),
    (x: B, y: B) => (if x.isSome: x else: y),
    () => none[int]()
  )

for i in 1..9:
  for k in 0..<N:
    nanachi[i][k+1] = (nanachi[i][k] * 10 + i) mod MOD

for _ in range(Q):
  input:
    (L, R, D): int
  segt.apply(L-1..<R, option(D))
  echo segt.prod(0..<N).get[0]
