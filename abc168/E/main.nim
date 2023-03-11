#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

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

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

const MOD = 1000000007
var N:int
var A:seq[int]
var B:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
#}}}

#{{{ ModInt[Mod]

type ModInt[Mod: static[int]] = object
  v:int32

proc initModInt[T](a:T, Mod:static[int]):ModInt[Mod] =
  when T is ModInt:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    return ModInt[Mod](v:a.int32)

#proc init[Mod: static[int], T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity[Mod: static[int]](self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[Mod: static[int],T](a:ModInt[Mod], b:T):bool = a.v == initModInt(b, Mod).v
proc `!=`[Mod: static[int],T](a:ModInt[Mod], b:T):bool = a.v != initModInt(b, Mod).v
proc `-`[Mod: static[int]](self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0: return self
  else: return ModInt[Mod](v:Mod - self.v)
proc `$`[Mod: static[int]](a:ModInt[Mod]):string = return $(a.v)

proc `+=`[Mod: static[int], T](self:var ModInt[Mod]; a:T) =
  self.v += initModInt(a, Mod).v
  if self.v >= Mod: self.v -= Mod
proc `-=`[Mod: static[int], T](self:var ModInt[Mod], a:T) =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += Mod
proc `*=`[Mod: static[int], T](self:var ModInt[Mod],a:T) =
  self.v = (self.v.int * initModInt(a, Mod).v.int mod Mod).int32
proc `^=`[Mod: static[int]](self:var ModInt[Mod], n:int) =
  var (x,n,a) = (self,n,self.Identity)
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)
proc inverse[Mod:static[int]](self: ModInt[Mod]):ModInt[Mod] =
  var
    a = self.v.int
    b = Mod
    u = 1
    v = 0
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  return initModInt(u, Mod)
proc `/=`[Mod: static[int], T](a:var ModInt[Mod],b:T):void =
  a *= initModInt(b, Mod).inverse()
proc `+`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = 
  result = a;result += b
proc `-`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result -= b
proc `*`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a;result *= b
proc `/`[Mod: static[int], T](a:ModInt[Mod],b:T):ModInt[Mod] = result = a; result /= b
proc `^`[Mod: static[int]](a:ModInt[Mod],b:int):ModInt[Mod] = result = a; result ^= b
##}}}

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)
converter toMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)
proc `$`(a:Mint):string = $(a.v)

#{{{ default-table
proc getDefault(T:typedesc): T =
  when T is string: ""
  elif T is seq: @[]
  else:
    (var temp:T;temp)

proc getDefault[T](x:T): T = getDefault(T)

import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, getDefault(B))
  tables.`[]`(self, key)
#}}}

proc normalize(a:(int,int)):(int,int) =
  var a = a
  if a[0] < 0: a[0] *= -1;a[1] *= -1
  elif a[0] == 0:
    if a[1] < 0: a[1] *= -1
  let g = gcd(a[0].abs, a[1].abs)
  a[0] = a[0] div g
  a[1] = a[1] div g
  return a

proc main() =
  var
    ans = Mint(1)
    tb = initTable[(int,int),int]()
    vis = initSet[(int,int)]()
    z = 0
  for i in 0..<N:
    if A[i] == 0 and B[i] == 0:
      z.inc
      continue
    let a = (A[i], B[i]).normalize
    tb[a].inc
  for k,v in tb:
    if k in vis: continue
    let k2 = (k[1], -k[0]).normalize
    if k2 in vis: continue
    var p = Mint(0)
    if k in tb:
      p += Mint(2) ^ tb[k] - 1
    if k2 in tb:
      p += Mint(2) ^ tb[k2] - 1
    p += 1
    ans *= p
    vis.incl k
    vis.incl k2
  ans += z
  ans -= 1
  print ans
  return

main()
