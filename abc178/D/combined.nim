# {{{ header
when not declared ATCODER_CHAEMON_HEADER_HPP:
  const MOD = 1000000007

  # ModInt {{{
  when not declared ATCODER_MODINT_CHAEMON_HPP:
    const ATCODER_MODINT_CHAEMON_HPP* = 1
    import strformat
    import macros
    # ModInt[Mod] {{{
    type ModInt*[Mod: static[int]] = object
      v:int32
     
    proc initModInt*(a:SomeInteger, Mod:static[int]):ModInt[Mod] =
      var a = a.int
      a = a mod Mod
      if a < 0: a += Mod
      result.v = a.int32
     
    proc getMod[Mod:static[int]](self: ModInt[Mod]):static int32 = self.Mod
    proc getMod[Mod:static[int]](self: typedesc[ModInt[Mod]]):static int32 = self.Mod
     
    macro declareModInt*(Mod:static[int], t: untyped):untyped =
      var strBody = ""
      strBody &= fmt"""
type {t.repr}* = ModInt[{Mod.repr}]
proc init{t.repr}*(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
proc `$`*(a:{t.repr}):string = $(a.v)
converter to{t.repr}*(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
"""
      parseStmt(strBody)
     
    when declared(Mod): declareModInt(Mod, Mint)
    ##}}}
     
    # DynamicModInt {{{
    type DMint* = object
      v:int32
     
    proc setModSub*(self:typedesc[not ModInt], m:int = -1, update = false):int32 =
      {.noSideEffect.}:
        var DMOD {.global.}:int32
        if update: DMOD = m.int32
        return DMOD
     
    proc fastMod*(a:int,m:uint32):uint32{.inline.} =
      var
        minus = false
        a = a
      if a < 0:
        minus = true
        a = -a
      elif a < m.int:
        return a.uint32
      var
        xh = (a shr 32).uint32
        xl = a.uint32
        d:uint32
      asm """
        "divl %4; \n\t"
        : "=a" (`d`), "=d" (`result`)
        : "d" (`xh`), "a" (`xl`), "r" (`m`)
      """
      if minus and result > 0'u32: result = m - result
    proc initDMint*(a:SomeInteger, Mod:int):DMint = result.v = fastMod(a.int, Mod.uint32).int32
     
    proc getMod*[T:not ModInt](self: T):int32 = T.type.setModSub()
    proc getMod*(self: typedesc[not ModInt]):int32 = self.setModSub()
    proc setMod*(self: typedesc[not ModInt], m:int) = discard self.setModSub(m, update = true)
    #}}}
     
    # Operations {{{
    type ModIntC* = concept x, type T
      x.v
    #  x.v is int32
    #  x.getMod() is int32
    #  when T isnot ModInt: setMod(T, int)
    type SomeIntC* = concept x
      x is SomeInteger or x is ModIntC
     
    proc Identity*(self:ModIntC):auto = result = self;result.v = 1
    proc init*[Mod:static[int]](self:ModInt[Mod], a:SomeIntC):ModInt[Mod] =
      when a is SomeInteger: initModInt(a, Mod)
      else: a
    proc init*(self:ModIntC and not ModInt, a:SomeIntC):auto =
      when a is SomeInteger:
        var r = self.type.default
        r.v = fastMod(a.int, self.getMod().uint32).int32
        r
      else: a
     
    macro declareDMintConverter*(t:untyped) =
      parseStmt(fmt"""
converter to{t.repr}*(a:SomeInteger):{t.repr} =
  let Mod = {t.repr}.getMod()
  if Mod > 0:
    result.v = fastMod(a.int, Mod.uint32).int32
  else:
    result.v = a.int32
  return result
""")
     
    declareDMintConverter(DMint)
     
    macro declareDMint*(t:untyped) =
      parseStmt(fmt"""
type {t.repr} {{.borrow: `.`.}} = distinct DMint
declareDMintConverter({t.repr})
""")
     
    proc `*=`*(self:var ModIntC, a:SomeIntC) =
      when self is ModInt:
        self.v = (self.v.int * self.init(a).v.int mod self.getMod().int).int32
      else:
        self.v = fastMod(self.v.int * self.init(a).v.int, self.getMod().uint32).int32
    proc `==`*(a:ModIntC, b:SomeIntC):bool = a.v == a.init(b).v
    proc `!=`*(a:ModIntC, b:SomeIntC):bool = a.v != a.init(b).v
    proc `-`*(self:ModIntC):auto =
      if self.v == 0: return self
      else: return self.init(self.getMod() - self.v)
    proc `$`*(a:ModIntC):string = return $(a.v)
     
    proc `+=`*(self:var ModIntC; a:SomeIntC) =
      self.v += self.init(a).v
      if self.v >= self.getMod(): self.v -= self.getMod()
    proc `-=`*(self:var ModIntC, a:SomeIntC) =
      self.v -= self.init(a).v
      if self.v < 0: self.v += self.getMod()
    proc `^=`*(self:var ModIntC, n:SomeInteger) =
      var (x,n,a) = (self,n,self.Identity)
      while n > 0:
        if (n and 1) > 0: a *= x
        x *= x
        n = (n shr 1)
      swap(self, a)
    proc inv*(self: ModIntC):auto =
      var
        a = self.v.int
        b = self.getMod().int
        u = 1
        v = 0
      while b > 0:
        let t = a div b
        a -= t * b;swap(a, b)
        u -= t * v;swap(u, v)
      return self.init(u)
    proc `/=`*(a:var ModIntC,b:SomeIntC) = a *= a.init(b).inv()
    proc `+`*(a:ModIntC,b:SomeIntC):auto = result = a;result += b
    proc `-`*(a:ModIntC,b:SomeIntC):auto = result = a;result -= b
    proc `*`*(a:ModIntC,b:SomeIntC):auto = result = a;result *= b
    proc `/`*(a:ModIntC,b:SomeIntC):auto = result = a;result /= b
    proc `^`*(a:ModIntC,b:SomeInteger):auto = result = a;result ^= b
    # }}}
  # }}}
  
  const ATCODER_CHAEMON_HEADER_HPP = 1
  {.hints:off checks:off warnings:off assertions:on optimization:speed.}
  import algorithm
  import sequtils
  import tables
  import macros
  import math
  import sets
  import strutils
  import strformat
  import sugar
  
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

var S:int

# input part {{{
proc main()
block:
  S = nextInt()
#}}}

# ModInt {{{
when not declared ATCODER_MODINT_CHAEMON_HPP:
  const ATCODER_MODINT_CHAEMON_HPP* = 1
  import strformat
  import macros
  # ModInt[Mod] {{{
  type ModInt*[Mod: static[int]] = object
    v:int32
   
  proc initModInt*(a:SomeInteger, Mod:static[int]):ModInt[Mod] =
    var a = a.int
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a.int32
   
  proc getMod[Mod:static[int]](self: ModInt[Mod]):static int32 = self.Mod
  proc getMod[Mod:static[int]](self: typedesc[ModInt[Mod]]):static int32 = self.Mod
   
  macro declareModInt*(Mod:static[int], t: untyped):untyped =
    var strBody = ""
    strBody &= fmt"""
type {t.repr}* = ModInt[{Mod.repr}]
proc init{t.repr}*(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
proc `$`*(a:{t.repr}):string = $(a.v)
converter to{t.repr}*(a:SomeInteger):{t.repr} = initModInt(a, {Mod.repr})
"""
    parseStmt(strBody)
   
  when declared(Mod): declareModInt(Mod, Mint)
  ##}}}
   
  # DynamicModInt {{{
  type DMint* = object
    v:int32
   
  proc setModSub*(self:typedesc[not ModInt], m:int = -1, update = false):int32 =
    {.noSideEffect.}:
      var DMOD {.global.}:int32
      if update: DMOD = m.int32
      return DMOD
   
  proc fastMod*(a:int,m:uint32):uint32{.inline.} =
    var
      minus = false
      a = a
    if a < 0:
      minus = true
      a = -a
    elif a < m.int:
      return a.uint32
    var
      xh = (a shr 32).uint32
      xl = a.uint32
      d:uint32
    asm """
      "divl %4; \n\t"
      : "=a" (`d`), "=d" (`result`)
      : "d" (`xh`), "a" (`xl`), "r" (`m`)
    """
    if minus and result > 0'u32: result = m - result
  proc initDMint*(a:SomeInteger, Mod:int):DMint = result.v = fastMod(a.int, Mod.uint32).int32
   
  proc getMod*[T:not ModInt](self: T):int32 = T.type.setModSub()
  proc getMod*(self: typedesc[not ModInt]):int32 = self.setModSub()
  proc setMod*(self: typedesc[not ModInt], m:int) = discard self.setModSub(m, update = true)
  #}}}
   
  # Operations {{{
  type ModIntC* = concept x, type T
    x.v
  #  x.v is int32
  #  x.getMod() is int32
  #  when T isnot ModInt: setMod(T, int)
  type SomeIntC* = concept x
    x is SomeInteger or x is ModIntC
   
  proc Identity*(self:ModIntC):auto = result = self;result.v = 1
  proc init*[Mod:static[int]](self:ModInt[Mod], a:SomeIntC):ModInt[Mod] =
    when a is SomeInteger: initModInt(a, Mod)
    else: a
  proc init*(self:ModIntC and not ModInt, a:SomeIntC):auto =
    when a is SomeInteger:
      var r = self.type.default
      r.v = fastMod(a.int, self.getMod().uint32).int32
      r
    else: a
   
  macro declareDMintConverter*(t:untyped) =
    parseStmt(fmt"""
converter to{t.repr}*(a:SomeInteger):{t.repr} =
  let Mod = {t.repr}.getMod()
  if Mod > 0:
    result.v = fastMod(a.int, Mod.uint32).int32
  else:
    result.v = a.int32
  return result
""")
   
  declareDMintConverter(DMint)
   
  macro declareDMint*(t:untyped) =
    parseStmt(fmt"""
  type {t.repr} {{.borrow: `.`.}} = distinct DMint
  declareDMintConverter({t.repr})
  """)
   
  proc `*=`*(self:var ModIntC, a:SomeIntC) =
    when self is ModInt:
      self.v = (self.v.int * self.init(a).v.int mod self.getMod().int).int32
    else:
      self.v = fastMod(self.v.int * self.init(a).v.int, self.getMod().uint32).int32
  proc `==`*(a:ModIntC, b:SomeIntC):bool = a.v == a.init(b).v
  proc `!=`*(a:ModIntC, b:SomeIntC):bool = a.v != a.init(b).v
  proc `-`*(self:ModIntC):auto =
    if self.v == 0: return self
    else: return self.init(self.getMod() - self.v)
  proc `$`*(a:ModIntC):string = return $(a.v)
   
  proc `+=`*(self:var ModIntC; a:SomeIntC) =
    self.v += self.init(a).v
    if self.v >= self.getMod(): self.v -= self.getMod()
  proc `-=`*(self:var ModIntC, a:SomeIntC) =
    self.v -= self.init(a).v
    if self.v < 0: self.v += self.getMod()
  proc `^=`*(self:var ModIntC, n:SomeInteger) =
    var (x,n,a) = (self,n,self.Identity)
    while n > 0:
      if (n and 1) > 0: a *= x
      x *= x
      n = (n shr 1)
    swap(self, a)
  proc inv*(self: ModIntC):auto =
    var
      a = self.v.int
      b = self.getMod().int
      u = 1
      v = 0
    while b > 0:
      let t = a div b
      a -= t * b;swap(a, b)
      u -= t * v;swap(u, v)
    return self.init(u)
  proc `/=`*(a:var ModIntC,b:SomeIntC) = a *= a.init(b).inv()
  proc `+`*(a:ModIntC,b:SomeIntC):auto = result = a;result += b
  proc `-`*(a:ModIntC,b:SomeIntC):auto = result = a;result -= b
  proc `*`*(a:ModIntC,b:SomeIntC):auto = result = a;result *= b
  proc `/`*(a:ModIntC,b:SomeIntC):auto = result = a;result /= b
  proc `^`*(a:ModIntC,b:SomeInteger):auto = result = a;result ^= b
  # }}}
# }}}

proc main() =
  var dp: array[2020, Mint]
  dp.fill(Mint(0))
  dp[0] = 1
  for i in 1..S:
    dp[i] = 0
    for d in 3..S:
      if d > i: break
      dp[i] += dp[i - d]
  print dp[S]
  return

main()

