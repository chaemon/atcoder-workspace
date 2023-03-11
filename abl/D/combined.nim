# header {{{
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const ATCODER_CHAEMON_HEADER_HPP* = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import std/algorithm as algorithm_lib
  import std/sequtils as sequtils_lib
  import std/tables as tables_lib
  import std/macros as macros_lib
  import std/math as math_lib
  import std/sets as sets_lib
  import std/strutils as strutils_lib
  import std/strformat as strformat_lib
  import std/sugar as sugar_lib
  
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
when not declared ATCODER_SEGTREE_HPP:
  const ATCODER_SEGTREE_HPP* = 1
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
  import std/sugar
  import std/sequtils

  type segtree*[S; p:static[tuple]] = object
    n, size, log:int
    d: seq[S]

  proc update[ST:segtree](self: var ST, k:int) {.inline.} =
    let op = ST.p.op
    self.d[k] = op(self.d[2 * k], self.d[2 * k + 1])

  proc init*[ST:segtree](self: var ST, v:seq[ST.S]) =
    let
      n = v.len
      log = ceil_pow2(n)
      size = 1 shl log
    self.n = n
    self.size = size
    self.log = log
    let e = ST.p.e
    self.d = newSeqWith(2 * size, e())
    for i in 0..<n: self.d[size + i] = v[i]
    for i in countdown(size - 1, 1): self.update(i)
  proc init*[ST:segtree](self: var ST, n:int) =
    let e = ST.p.e
    self.init(newSeqWith(n, e()))
  proc init*[ST:segtree](self: typedesc[ST], v:seq[ST.S]):auto =
    result = ST()
    result.init(v)
  proc init*[ST:segtree](self: typedesc[ST], n:int):auto =
    let e = ST.p.e
    self.init(newSeqWith(n, e()))
  proc initSegTree*[S](v:seq[S], op:static[(S,S)->S], e:static[()->S]):auto =
    result = segtree[S, (op:op, e:e)]()
    result.init(v)
  proc initSegTree*[S](n:int, op:static[(S,S)->S], e:static[()->S]):auto =
    result = segtree[S, (op:op, e:e)]()
    result.init(newSeqWith(n, e()))

  proc set*[ST:segtree](self:var ST, p:int, x:ST.S) {.inline.} =
    assert p in 0..<self.n
    var p = p + self.size
    self.d[p] = x
    for i in 1..self.log: self.update(p shr i)

  proc get*[ST:segtree](self:ST, p:int):ST.S {.inline.} =
    assert p in 0..<self.n
    return self.d[p + self.size]

  proc prod*[ST:segtree](self:ST, p:Slice[int]):ST.S {.inline.} =
    var (l, r) = (p.a, p.b + 1)
    assert 0 <= l and l <= r and r <= self.n
    let e = ST.p.e
    var sml, smr = e()
    l += self.size; r += self.size
    while l < r:
      let op = ST.p.op
      if (l and 1) != 0: sml = op(sml, self.d[l]);l.inc
      if (r and 1) != 0: r.dec;smr = op(self.d[r], smr)
      l = l shr 1
      r = r shr 1
    let op = ST.p.op
    return op(sml, smr)

  proc all_prod*[ST:segtree](self:ST):ST.S = self.d[1]

#  proc max_right*[ST:segtree, f:static[proc(s:ST.S):bool]](self:ST, l:int):auto = self.max_right(l, f)
  proc max_right*[ST:segtree](self:ST, l:int, f:proc(s:ST.S):bool):int =
    assert l in 0..self.n
    let e = ST.p.e
    let f = f
    assert f(e())
    if l == self.n: return self.n
    var
      l = l + self.size
      sm = e()
    while true:
      while l mod 2 == 0: l = l shr 1
      let op = ST.p.op
      let f = f
      if not f(op(sm, self.d[l])):
        while l < self.size:
          l = (2 * l)
          let op = ST.p.op
          let f = f
          if f(op(sm, self.d[l])):
            let op = ST.p.op
            sm = op(sm, self.d[l])
            l.inc
        return l - self.size
      sm = op(sm, self.d[l])
      l.inc
      if not ((l and -l) != l): break
    return self.n

#  proc min_left*[ST:segtree, f:static[proc(s:ST.S):bool]](self:ST, r:int):auto = self.min_left(r, f)
  proc min_left*[ST:segtree](self:ST, r:int, f:proc(s:ST.S):bool):int =
    assert r in 0..self.n
    let e = ST.p.e
    let f = f
    assert f(e())
    if r == 0: return 0
    var
      r = r + self.size
      sm = e()
    while true:
      r.dec
      while r > 1 and (r mod 2 != 0): r = r shr 1
      let op = ST.p.op
      let f = f
      if not f(op(self.d[r], sm)):
        while r < self.size:
          r = (2 * r + 1)
          let op = ST.p.op
          let f = f
          if f(op(self.d[r], sm)):
            let op = ST.p.op
            sm = op(self.d[r], sm)
            r.dec
        return r + 1 - self.size
      sm = op(self.d[r], sm)
      if not ((r and -r) != r): break
    return 0

var N:int
var K:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

const T = 300000

var st = initSegtree(T + 1, (a:int, b:int)=>max(a, b), () => -int.inf)

proc main() =
  for i in 0..<N:
    let
      l = max(0, A[i] - K)
      r = min(T, A[i] + K)
      u = st.prod(l..r)
    if st.get(A[i]) == -int.inf:
      st.set(A[i], 1)
    let p = st.get(A[i])
    st.set(A[i], max(u + 1, p))
  echo st.all_prod()
  return

main()

