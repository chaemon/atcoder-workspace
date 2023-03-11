#{{{ header
{.hints:off warnings:off optimization:speed checks:off.}
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
type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
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

# newSeqWith {{{
from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

const MOD = 1000000007
var N:int
var E:string
var A:string

#{{{ ModInt[Mod]
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

type ModInt[Mod: static[int]] = object
  v:int
proc initModInt[T](a:T, Mod: static[int]):ModInt[Mod] =
  when T is ModInt[Mod]:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a
proc initModInt[T](a:T):ModInt[Mod] = initModInt(a, MOD)
proc init[T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity(self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[T](a:ModInt[Mod], b:T):bool = a.v == a.init(b).v
proc `!=`[T](a:ModInt[Mod], b:T):bool = a.v != a.init(b).v
proc `-`(self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0: return self
  else: return ModInt[Mod](v:MOD - self.v)
proc `$`(a:ModInt[Mod]):string = return $(a.v)

proc `+=`[T](self:var ModInt[Mod]; a:T):void =
  self.v += initModInt(a, Mod).v
  if self.v >= MOD: self.v -= MOD
proc `-=`[T](self:var ModInt[Mod],a:T):void =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += MOD
proc `*=`[T](self:var ModInt[Mod],a:T):void =
  self.v *= initModInt(a, Mod).v
  self.v = self.v mod MOD
proc `^=`(self:var ModInt[Mod], n:int) =
  var (x,n,a) = (self,n,self.Identity)
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)
proc inverse(x:int):ModInt[Mod] =
  var (a, b) = (x, MOD)
  var (u, v) = (1, 0)
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  return initModInt(u, Mod)
proc `/=`[T](a:var ModInt[Mod],b:T):void = a *= initModInt(b, Mod).v.inverse()
proc `+`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result += b
proc `-`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result -= b
proc `*`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result *= b
proc `/`[T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a; result /= b
proc `^`(a:ModInt[Mod],b:int):ModInt[Mod] = result = a; result ^= b
#}}}

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)

#{{{ input part
proc main()
block:
  N = nextInt()
  E = nextString()
  A = nextString()
#}}}

proc plus(x,y:int):int =
  if x != y:
    var x2 = x + 1
    if x2 == 3: x2 = 0
    if x2 == y: return x
    else: return y
  else: return x

proc minus(x,y:int):int =
  if x != y:
    var x2 = x + 1
    if x2 == 3: x2 = 0
    if x2 == y: return y
    else: return x
  else: return x

proc mult(x, y:int):int =
  if x != y:
    return 3 - x - y
  else:
    return x

proc plus(x, y:(int,int,int)):(int,int,int) =
  return ((x[0] * y[0] + x[0] * y[1] + x[1] * y[0]) mod MOD, 
          (x[1] * y[1] + x[1] * y[2] + x[2] * y[1]) mod MOD, 
          (x[2] * y[2] + x[2] * y[0] + x[0] * y[2]) mod MOD)
proc minus(x, y:(int,int,int)):(int,int,int) =
  return ((x[0] * y[0] + x[0] * y[2] + x[2] * y[0]) mod MOD, 
          (x[1] * y[1] + x[1] * y[0] + x[0] * y[1]) mod MOD, 
          (x[2] * y[2] + x[2] * y[1] + x[1] * y[2]) mod MOD)
proc mult(x, y:(int,int,int)):(int,int,int) =
  return ((x[0] * y[0] + x[1] * y[2] + x[2] * y[1]) mod MOD, 
          (x[1] * y[1] + x[2] * y[0] + x[0] * y[2]) mod MOD, 
          (x[2] * y[2] + x[0] * y[1] + x[1] * y[0]) mod MOD)

main()

proc term(i:var int):(int,int,int)
proc factor(i:var int):(int,int,int)

proc expr(i:var int):(int,int,int) =
#  echo "expr: ", i
  if i == N: doAssert(false)
  var v = term(i)
  while i < N and (E[i] == '+' or E[i] == '-'):
    if E[i] == '+':
      i += 1
      v = v.plus(term(i))
    elif E[i] == '-':
      i += 1
      v = v.minus(term(i))
    else:
      doAssert(false)
  return v


proc term(i:var int):(int,int,int) =
#  echo "term: ", i
  if i == N: doAssert(false)
  var v = factor(i)
  while i < N and E[i] == '*':
    i += 1
    v = v.mult(factor(i))
  return v
proc factor(i:var int):(int,int,int) =
#  echo "factor: ", i
  if E[i] == '(':
    i += 1
    result = expr(i)
    i += 1
    return
  elif E[i] == 'R':
    result = (1,0,0)
  elif E[i] == 'S':
    result = (0,1,0)
  elif E[i] == 'P':
    result = (0,0,1)
  elif E[i] == '?':
    result = (1,1,1)
  else:
    assert(false)
  i += 1

proc main() =
  var i = 0
  let v = expr(i)
  assert(i == N)
  if A == "R":
    echo v[0]
  elif A == "S":
    echo v[1]
  else:
    echo v[2]
  return
