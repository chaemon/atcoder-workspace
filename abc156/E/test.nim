#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
  while true:
    let c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

proc discardableId[T](x: T): T {.discardable.} =
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
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r
#}}}

#{{{ ModInt[Mod]
proc default(T:typedesc): T = (var temp:T;temp)
proc default[T](x:T): T = (var temp:T;temp)

type ModInt[Mod: static[int]] = object
  v:int
#proc initModInt[Mod: static[int]](a:int):ModInt[Mod] =
#  var a = a
#  a = a mod Mod
#  if a < 0: a += Mod
#  result.v = a
#proc initModInt[Mod: static[int]](a:ModInt[Mod]):ModInt[Mod] =
#  return a
proc initModInt[T](a:T, Mod: static[int]):ModInt[Mod] =
  when T is ModInt:
    return a
  else:
    var a = a.int
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a

proc init[T](self:ModInt, a:T):ModInt = initModInt(a, self.Mod)
proc Identity(self:ModInt):ModInt = return initModInt(1, self.Mod)
converter toModInt[N:static[int]](a:int):ModInt[N] =
  return initModInt(a, N)
#  var a = a.int
#  a = a mod Mod
#  if a < 0: a += Mod
#  result.v = a
converter toInt(a:ModInt):int = a.v

proc `==`[T](a:ModInt, b:T):bool = a.int == a.init(b).int
proc `!=`[T](a:ModInt, b:T):bool = a.int != a.init(b).int
proc `-`[Mod: static[int]](self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0: return self
  else: return ModInt[Mod](v:Mod - self.int)
proc `$`(a:ModInt):string = return $(a.int)

proc `+=`[T](self:var ModInt; a:T) =
  self.v += initModInt(a.int, self.Mod).int
  if self.v >= self.Mod: self.v -= self.Mod
proc `-=`[T](self:var ModInt,a:T) =
  self.v -= initModInt(a.int, self.Mod).int
  if self.v < 0: self.v += self.Mod
proc `*=`[T](self:var ModInt,a:T) =
  self.v = self.int * initModInt(a, self.Mod).int
  self.v = self.int mod self.Mod
proc `^=`(self:var ModInt, n:int) =
  var (x,n,a) = (self,n,initModInt(1, self.Mod))
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)

proc inverse(x:ModInt):ModInt =
  var
    a = x.int
    b = x.Mod
    u = 1
    v = 0
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  initModInt(u, x.Mod)

proc `/=`[T](a:var ModInt,b:T) =
  let b2 = initModInt(b, a.Mod)
  a *= inverse(b2)
proc `+`[T](a:ModInt,b:T):ModInt = result = a;result += b
proc `-`[T](a:ModInt,b:T):ModInt = result = a;result -= b
proc `*`[T](a:ModInt,b:T):ModInt = result = a;result *= b
proc `/`[T](a:ModInt,b:T):ModInt = result = a; result /= b
proc `^`(a:ModInt,b:int):ModInt = result = a; result ^= b
#}}}

const MOD = 1000000007

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[MOD] = initModInt(a, MOD)
#converter toMint[T:SomeInteger](a:T):ModInt[MOD] = initModInt(a, MOD)

block main:
  var t = initModInt(12, 7)
  echo initModInt(t, 7).int
  echo toModInt[13](4)
#  var s = ModInt[19](13)
  var u = default(ModInt[19]).init(13)
#  var v = Mint(1000000009)
  echo u
  t += 3
  t -= 3
  t *= 3
  t *= t
  t = t * t
  t = t - t
  t = t + t
  t = t / t
  t /= 3
  t /= t
  u ^= 2020
  echo -t
  echo u^2020
  discard
