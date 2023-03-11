# header {{{
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

template SeqImpl(lens: varargs[int]; init; d: int): untyped =
  when d + 1 == lens.len:
    when init is typedesc: newSeq[init](lens[d])
    else: newSeqWith(lens[d], init)
  else: newSeqWith(lens[d], SeqImpl(lens, init, d + 1))

template Seq(lens: varargs[int]; init): untyped = SeqImpl(lens, init, 0)

template ArrayImpl(lens: varargs[int]; init: typedesc; d: int): typedesc =
  when d + 1 == lens.len: array[lens[d], init]
  else: array[lens[d], ArrayImpl(lens, init, d + 1)]

template ArrayFill(a, val): void =
  when a is array:
    for v in a.mitems: ArrayFill(v, val)
  else:
    a = val

template Array(lens: varargs[int]; init): auto =
  when init is typedesc:
    ArrayImpl(@lens, init, 0).default
  else:
    var a:ArrayImpl(@lens, typeof(init), 0)
    ArrayFill(a, init)
    a
#}}}

const MOD = 998244353
var S:string
var K:int

# input part {{{
proc main()
block:
  S = nextString()
  K = nextInt()
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

#const B = 305
const B = 10

proc main() =
  let N = S.len
  var
    a = newSeq[int]()
    s = 0
  for i in 0..<N:
    if S[i] == '1':
      a.add(s)
    else:
      s.inc
  K.min=a.len
  dump(a)
  block:
    var
      ct = 0
    for i in 0..a[0]:
      for j in i..a[1]:
        for k in j..a[2]:
          for l in k..a[3]:
            var num = 0
            if i < a[0]: num.inc
            if j < a[1]: num.inc
            if k < a[2]: num.inc
            if l < a[3]: num.inc
            dump(num)
            if num <= K:
              ct.inc
    dump(ct)


  var
    dp = Array(B, B, initMint(0))
    sum = Array(B, B, initMint(0))
  dp[0][0] = initMint(1)
  for i in 0..<a.len:
    dump(dp)
    for k in 0..<dp[0].len:
      var s = initMint(0)
      for b in 0..<dp.len:
        s += dp[b][k]
        sum[b][k] = s
    var dp2 = Array(B, B, initMint(0))
    for b in 0..a[i]:
      for k in 0..N:
        let k2 = 
          if b == a[i]:
            min(k + 1, a.len)
          else:
            k
        dp2[b][k2] += sum[b][k]
    swap(dp, dp2)
  var ans = initMint(0)
  for b in 0..<dp.len:
    for k in 0..K:
      ans += dp[b][k]
  print ans
  return

main()

