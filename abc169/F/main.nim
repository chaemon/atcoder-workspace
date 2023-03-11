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

template SeqImpl(lens: seq[int]; init; d, l: static[int]): auto =
  when d == l:
    when init is typedesc: newSeq[init](lens[d - 1])
    else: newSeqWith(lens[d - 1], init)
  else: newSeqWith(lens[d - 1], SeqImpl(lens, init, d + 1, l))

template Seq(lens: varargs[int]; init): auto = SeqImpl(@lens, init, 1, lens.len)

template ArrayImpl(lens: varargs[int]; init: typedesc; d, l: static[int]): typedesc =
  when d == l: array[lens[d - 1], init]
  else: array[lens[d - 1], ArrayImpl(lens, init, d + 1, l)]

template ArrayFill(a, val): void =
  when a is array:
    for v in a.mitems: ArrayFill(v, val)
  else:
    a = val
  discard

template Array(lens: varargs[int]; init): auto =
  when init is typedesc:
    ArrayImpl(@lens, init, 1, lens.len).default
  else:
    var a:ArrayImpl(@lens, typeof(init), 1, lens.len)
    ArrayFill(a, init)
    a
#}}}

const MOD = 998244353
var N:int
var S:int
var A:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  S = nextInt()
  A = newSeqWith(N, nextInt())
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

proc main() =
  let inv2 = Mint(1)/2
  var dp = Seq(S + 1, Mint(0))
  dp[0] = Mint(1)
  for i in 0..<N:
    var dp2 = dp
    for s in 0..S:
      let s2 = s + A[i]
      if s2 > S: continue
      dp2[s2] += dp[s] * inv2
    swap(dp, dp2)
  print dp[S] * Mint(2)^N
  return

main()
