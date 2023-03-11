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
  
  when not declared ATCODER_READER_HPP:
    const ATCODER_READER_HPP* = 1
    import streams
    import strutils
    import sequtils
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
    discard
  when not declared ATCODER_SLICEUTILS_HPP:
    const ATCODER_SLICEUTILS_HPP* = 1
    proc index*[T](a:openArray[T]):Slice[int] =
      a.low..a.high
    type ReversedSlice[T] = distinct Slice[T]
    type StepSlice[T] = object
      s:Slice[T]
      d:T
    proc reversed*[T](p:Slice[T]):auto = ReversedSlice[T](p)
    iterator items*[T](p:ReversedSlice[T]):T =
      var i = Slice[T](p).b
      while true:
        yield i
        if i == Slice[T](p).a:break
        i.dec
    proc `>>`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d:d)
    proc `<<`*[T](s:Slice[T], d:T):StepSlice[T] =
      assert d != 0
      StepSlice[T](s:s, d: -d)
    proc low*[T](s:StepSlice[T]):T = s.s.a
    proc high*[T](s:StepSlice[T]):T =
      let p = s.s.b - s.s.a
      if p < 0: return s.low - 1
      let d = abs(s.d)
      return s.s.a + (p div d) * d
    iterator items*[T](p:StepSlice[T]):T = 
      assert p.d != 0
      if p.s.a <= p.s.b:
        if p.d > 0:
          var i = p.low
          let h = p.high
          while true:
            yield i
            if i == h: break
            i += p.d
        else:
          var i = p.high
          let l = p.low
          while true:
            yield i
            if i == l: break
            i += p.d
    proc `[]`*[T:SomeInteger, U](a:openArray[U], s:Slice[T]):seq[U] =
      for i in s:result.add(a[i])
    proc `[]=`*[T:SomeInteger, U](a:var openArray[U], s:StepSlice[T], b:openArray[U]) =
      var j = 0
      for i in s:
        a[i] = b[j]
        j.inc
    discard
  when not declared ATCODER_MAX_MIN_OPERATOR_HPP:
    const ATCODER_MAX_MIN_OPERATOR_HPP* = 1
    template `max=`*(x,y:typed):void = x = max(x,y)
    template `min=`*(x,y:typed):void = x = min(x,y)
    discard
  when not declared ATCODER_INF_HPP:
    const ATCODER_INF_HPP* = 1
    template inf*(T): untyped = 
      when T is SomeFloat: T(Inf)
      elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
      else:
        static: assert(false)
    discard
  when not declared ATCODER_CHAEMON_WARLUS_OPERATOR_HPP:
    const ATCODER_CHAEMON_WARLUS_OPERATOR_HPP* = 1
    import strformat
    import macros
    proc discardableId*[T](x: T): T {.discardable.} = x
  
    macro `:=`*(x, y: untyped): untyped =
      var strBody = ""
      if x.kind == nnkPar:
        for i,xi in x:
          strBody &= fmt"""{'\n'}{xi.repr} := {y[i].repr}{'\n'}"""
      else:
        strBody &= fmt"""{'\n'}when declaredInScope({x.repr}):{'\n'}  {x.repr} = {y.repr}{'\n'}else:{'\n'}  var {x.repr} = {y.repr}{'\n'}"""
      strBody &= fmt"discardableId({x.repr})"
      parseStmt(strBody)
    discard
  when not declared ATCODER_SEQ_ARRAY_UTILS:
    const ATCODER_SEQ_ARRAY_UTILS* = 1
    import strformat
    import macros
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
    discard
  when not declared ATCODER_DEBUG_HPP:
    const ATCODER_DEBUG_HPP* = 1
    import macros
    import strformat
    import terminal
    
    macro debug*(n: varargs[untyped]): untyped =
    #  var a = "stderr.write "
      var a = ""
      a.add "setForegroundColor fgYellow\n"
      a.add "echo "
      for i,x in n:
        a = a & fmt""" "{x.repr} = ", {x.repr} """
        if i < n.len - 1:
          a.add(""", ", ",""")
      a.add "\n"
      a.add "resetAttributes()"
      parseStmt(a)
    discard

#import atcoder/modint
when not declared ATCODER_MONTGOMERY_MODINT_HPP:
  const ATCODER_MONTGOMERY_MODINT_HPP* = 1

  import std/macros
  import std/strformat

  type StaticLazyMontgomeryModInt*[M:static[uint32]] = object
    a:uint32
  type DynamicLazyMontgomeryModInt*[T:static[int]] = object
    a:uint32
  type LazyMontgomeryModInt = StaticLazyMontgomeryModInt or DynamicLazyMontgomeryModInt

  proc get_r*(M:uint32):auto =
    result = M
    for i in 0..<4: result *= 2.uint32 - M * result
  proc get_n2*(M:uint32):auto = (((not M.uint) + 1.uint) mod M.uint).uint32

  proc getMontgomeryParameters(M:uint32):tuple[M, r, n2:uint32] =
    (M, get_r(M), get_n2(M))

  proc getParameters*[T:static[int]](t:typedesc[DynamicLazyMontgomeryModInt[T]]):ptr[tuple[M, r, n2:uint32]] =
    var p {.global.} : tuple[M, r, n2:uint32] = getMontgomeryParameters(998244353.uint32)
    return p.addr

  proc checkParameters(M, r:uint32) =
    assert r * M == 1, "invalid, r * mod != 1"
    assert M < (1 shl 30), "invalid, mod >= 2 ^ 30"
    assert (M and 1) == 1, "invalid, mod % 2 == 0"


  proc setMod*[T:static[int]](self:typedesc[DynamicLazyMontgomeryModInt[T]], M:SomeInteger) =
    let p = getMontgomeryParameters(M.uint32)
    checkParameters(p.M, p.r)
    (self.getParameters)[] = p

  template getMod*[T:StaticLazyMontgomeryModInt](self:T or typedesc[T]):auto = T.M
  template getMod*[T:static[int]](self:typedesc[DynamicLazyMontgomeryModInt[T]] or DynamicLazyMontgomeryModInt[T]):auto =
    (DynamicLazyMontgomeryModInt[T].getParameters)[].M
  template `mod`*[T:LazyMontgomeryModInt](self:T or typedesc[T]):int = T.get_mod.int

  template reduce(T:typedesc[LazyMontgomeryModInt], b:uint):auto =
    when T is StaticLazyMontgomeryModInt:
      const M = T.get_mod
      const r = get_r(M)
      static:
        checkParameters(M, r)
      ((b + (cast[uint32](b) * ((not r) + 1.uint32)).uint * M.uint) shr 32).uint32
    elif T is DynamicLazyMontgomeryModInt:
      let p = (T.getParameters)[]
      ((b + (cast[uint32](b) * ((not p.r) + 1.uint32)).uint * p.M.uint) shr 32).uint32
    else:
      assert false, "no such lazy montgomerymodint"

  proc init*[T:LazyMontgomeryModInt](t:typedesc[T], b:T or SomeInteger):auto {.inline.} =
    when b is LazyMontgomeryModInt: return b
    else:
      when b is SomeUnsignedInt:
        let b = (b.uint mod T.get_mod.uint).int
      when T is StaticLazyMontgomeryModInt:
        const n2 = get_n2(T.get_mod)
        return T(a:T.reduce((b.int mod T.get_mod.int + T.get_mod.int).uint * n2))
      elif T is DynamicLazyMontgomeryModInt:
        let p = (T.getParameters)[]
        return T(a:T.reduce((b.int mod p.M.int + p.M.int).uint * p.n2))

  proc val*[T:LazyMontgomeryModInt](self: T):int =
    var a = T.reduce(self.a.uint)
    if a >= T.get_mod: a -= T.get_mod
    return a.int

  proc `+=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a += b.a - 2.uint32 * T.get_mod
    if cast[int32](self.a) < 0.int32: self.a += 2.uint32 * T.get_mod
    return self

  proc `-=`*[T:LazyMontgomeryModInt](self: var T, b:T):T {.discardable, inline.} =
    self.a -= b.a
    if cast[int32](self.a) < 0.int32: self.a += 2.uint32 * T.get_mod
    return self

  proc inc*[T:LazyMontgomeryModInt](self: var T):T {.discardable, inline.} =
    return self += 1
  proc dec*[T:LazyMontgomeryModInt](self: var T):T {.discardable, inline.} =
    return self -= 1

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

  proc inv*[T:LazyMontgomeryModInt](self: T):T = self.pow(T.mod - 2)

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

  macro useStaticMontgomery*(name, M) =
    var strBody = ""
    strBody &= fmt"""type {name.repr}* = StaticLazyMontgomeryModInt[{M.repr}.uint32]{'\n'}converter to{name.repr}OfMontgomery*(n:int):{name.repr} {{.used.}} = {name.repr}.init(n){'\n'}"""
    parseStmt(strBody)
  macro useDynamicMontgomery*(name, M) =
    var strBody = ""
    strBody &= fmt"""type {name.repr}* = DynamicLazyMontgomeryModInt[{M.repr}.int]{'\n'}converter to{name.repr}OfMontgomery*(n:int):{name.repr} {{.used.}} = {name.repr}.init(n){'\n'}"""
    parseStmt(strBody)

  useStaticMontgomery(modint998244353, 998244353)
  useStaticMontgomery(modint1000000007, 1000000007)
  useDynamicMontgomery(modint, -1)

#type mint = modint1000000007
const MOD = 1000000007
#useStaticMontgomery(mint, MOD)
useDynamicMontgomery(mint, 2020)
#type mint = modint
mint.setMod(MOD)

proc solve(H:int, W:int, T:int) =
#  echo mint.getParameters()
  var a, b:int
  var c = 1
  # T * a == k * H
  a = H div gcd(T, H)
  b = W div gcd(T, W)
  c *= H div a
  c *= W div b
  var ans = mint(0)
  ans += 1
  ans += (mint(2)^a - 1)
  ans += (mint(2)^b - 1)
  let g = gcd(a, b)
  ans += (mint(2)^g - 2)
  ans = ans ^ c
  echo ans
  return

#{{{ main function
proc main() =
  var H = 0
  H = nextInt()
  var W = 0
  W = nextInt()
  var T = 0
  T = nextInt()
  solve(H, W, T);
  return

main()
#}}}
