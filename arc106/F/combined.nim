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

#import atcoder/modint
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
    when b is LazyMontgomeryModInt: b
    else:
      T(a:reduce((b.int mod T.M.int + T.M.int).uint * n2, T.M))

  macro useMontgomery*(name, M) =
    var strBody = ""
    strBody &= fmt"""type {name.repr}* = LazyMontgomeryModInt[{M.repr}.uint32]{'\n'}proc `$`*(m: {name.repr}): string {{.used.}} = system.`$`(m.val()){'\n'}converter to{name.repr}OfMontgomery*(n:int):{name.repr} {{.used.}} = {name.repr}.init(n){'\n'}"""
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
#  proc `==`*[T:LazyMontgomeryModInt](a, b:T):bool {.inline.} =
#    return (if a.a >= T.M: a.a - T.M else: a.a) == (if b.a >= T.M: b.a - T.M else: b.a)
  proc `==`*[T:LazyMontgomeryModInt](a:SomeInteger, b:T):bool {.inline.} =
    return T.init(a).val.uint32 == (if b.a >= T.M: b.a - T.M else: b.a)
  proc `==`*[T:LazyMontgomeryModInt](a:T, b:SomeInteger):bool {.inline.} =
    return (if a.a >= T.M: a.a - T.M else: a.a) == T.init(b).val.uint32

  template generateLazyMontgomeryModIntDefinitions(name, l, r, body: untyped): untyped {.dirty.} =
    proc name*[T:LazyMontgomeryModInt](l: T; r: T): auto {.inline.} =
      body
    proc name*[T:LazyMontgomeryModInt](l: SomeInteger; r: T): auto {.inline.} =
      body
    proc name*[T:LazyMontgomeryModInt](l: T; r: SomeInteger): auto {.inline.} =
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

#  proc `$`*[T:LazyMontgomeryModInt](m: T): string = (m.val()).toStr

  proc `-`*[T:LazyMontgomeryModInt](self:T):T = T.init(0) - self

  useMontgomery modint998244353, 998244353
  useMontgomery modint1000000007, 1000000007
# combination {{{
when not defined ATCODER_COMBINATION_HPP:
  const ATCODER_COMBINATION_HPP* = 1
  when not declared ATCODER_ELEMENT_CONCEPTS_HPP:
    const ATCODER_ELEMENT_CONCEPTS_HPP* = 1
    proc inv*[T:SomeFloat](a:T):auto = T(1) / a
    proc init*(self:typedesc[SomeFloat], a:SomeNumber):auto = self(a)
    type AdditiveGroupElem* = concept x, type T
      x + x
      x - x
      -x
      T(0)
    type MultiplicativeGroupElem* = concept x, type T
      x * x
      x / x
  #    x.inv()
      T(1)
    type RingElem* = concept x, type T
      x + x
      x - x
      -x
      x * x
      T(0)
      T(1)
    type FieldElem* = concept x, y, type T
      x + y
      x - y
      x * y
      x / y
      -x
      x.inv()
      T(0)
      T(1)
    type FiniteFieldElem* = concept x, type T
      T is FieldElem
      T.mod
      T.mod() is int
      x.pow(1000000)
      discard
    type hasInf* = concept x, type T
      T(Inf)
    discard

  type Combination*[T] = object
    fact_a, rfact_a: seq[T]

  type CombinationC* = concept x
    x is typedesc[FieldElem] or x is var Combination

  proc enhance[T:FieldElem](cmb: var Combination[T], k:int):auto =
    if k >= cmb.fact_a.len:
      if cmb.fact_a.len == 0:
        cmb.fact_a = @[T(1)]
        cmb.rfact_a = @[T(1)]
      let sz_old = cmb.fact_a.len - 1
      let sz = max(sz_old * 2, k)
      cmb.fact_a.setlen(sz + 1)
      cmb.rfact_a.setlen(sz + 1)
      for i in sz_old + 1..sz: cmb.fact_a[i] = cmb.fact_a[i-1] * T(i)
      cmb.rfact_a[sz] = T(1) / cmb.fact_a[sz]
      for i in countdown(sz - 1, sz_old + 1): cmb.rfact_a[i] = cmb.rfact_a[i + 1] * T(i + 1)
    return cmb.addr

  proc enhance(T:typedesc[FieldElem], k:int):auto {.discardable.} =
    var cmb{.global.} = Combination[T]()
    return cmb.enhance(k)
  
  template zero*(T:typedesc[FieldElem]):T = T(0)
  template zero*[T:FieldElem](cmb:Combination[T]):T = T(0)
  
  template fact*(T:CombinationC, k:int):auto = T.enhance(k)[].fact_a[k]
  template rfact*(T:CombinationC, k:int):auto = T.enhance(k)[].rfact_a[k]
  template inv*(T:CombinationC, k:int):auto = T.fact(k - 1) * T.rfact(k)

  template resetCombination*(T:typedesc[FieldElem] or var Combination) =
    var p = T.enhance(-1)
    p[].fact_a.setLen(0)
    p[].rfact_a.setLen(0)
  
  template P*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else: T.fact(n) * T.rfact(n - r)
  template C*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else: T.fact(n) * T.rfact(r) * T.rfact(n - r)
  template H*(T:CombinationC, n,r:int):auto =
    if n < 0 or r < 0: T.zero()
    elif r == 0: T.zero() + 1
    else: T.C(n + r - 1, r)
  template P_large*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else:
      var a = T(1)
      for i in 0..<r:a *= n - i
      a
  template C_large*(T:CombinationC, n,r:int):auto =
    if r < 0 or n < r: T.zero()
    else: T.P_large(n, r) * T.rfact(r)
  template H_large*(T:CombinationC, n,r:int):auto =
    if n < 0 or r < 0: T.zero()
    elif r == 0: T.zero() + 1
    else: T.C_large(n + r - 1, r)
# }}}

const MOD = 998244353

type mint = modint998244353

proc solve(N:int, d:seq[int]) =
  s := d.sum - N
  var p, v, w = mint(1)
  for i in 0..<N: p *= d[i]
  for i in 1..N - 2: p *= i
  p *= mint.C_large(s, N - 2)
  echo p
  return

# input part {{{
block:
  var N = nextInt()
  var d = newSeqWith(N, nextInt())
  solve(N, d)
#}}}
