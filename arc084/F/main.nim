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

# dump {{{
import macros

macro dump*(n: varargs[untyped]): untyped =
  result = newNimNode(nnkStmtList, n)
  for i,x in n:
    result.add(newCall("write", newIdentNode("stderr"), toStrLit(x)))
    result.add(newCall("write", newIdentNode("stderr"), newStrLitNode(" = ")))
    result.add(newCall("write", newIdentNode("stderr"), x))
    if i < n.len - 1: result.add(newCall("write", newIdentNode("stderr"), newStrLitNode(", ")))
  result.add(newCall("write", newIdentNode("stderr"), newStrLitNode("\n")))
# }}}

const MOD = 998244353
var N:int
var X:string
var A:seq[string]

#{{{ input part
proc main()
block:
  N = nextInt()
  X = nextString()
  A = newSeqWith(N, nextString())
#}}}

#{{{ bitutils
import bitops

proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if b.testBit(n): 1 else: 0)
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (B(1) shl (s.b - s.a + 1))

proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.clearBit(n)
  elif t == 1: b.setBit(n)
  else: doAssert(false)
proc writeBits[B:SomeInteger](b:B) =
  var n = sizeof(B) * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B =
  if n == 64:
    return not uint64(0)
  else:
    return (B(1) shl B(n)) - B(1)
iterator subsets[B:SomeInteger](b:B):B =
  var v = newSeq[int]()
  for i in 0..<(8 * sizeof(B)):
    if b[i] == 1: v.add(i)
  var s = B(0)
  yield s
  while true:
    var found = false
    for i in v:
      if not s.testBit(i):
        found = true
        s.setBit(i)
        yield s
        break
      else:
        s[i] = 0
    if not found: break
#}}}

#{{{ bitset
import strutils, sequtils, algorithm

const BitWidth = 64

proc toBin(b:uint64, n: int): string =
  result = ""
  for i in countdown(n-1, 0):
    if (b and (1'u64 shl uint64(i))) != 0'u64: result &= "1"
    else: result &= "0"

type StaticBitSet[N:static[int]] = ref object
  data: array[(N + BitWidth - 1) div BitWidth, uint64]

proc initStaticBitSet[N:static[int]](): StaticBitSet[N] =
  const size = (N + BitWidth - 1) div BitWidth
  var data: array[size, uint64]
  return StaticBitSet[N](data: data)
proc initStaticBitSet1[N:static[int]](): StaticBitSet[N] =
  result = initStaticBitSet(N)
  let
    q = (N + BitWidth - 1) div BitWidth
    r = N div BitWidth
  for i in 0..<q:result.data[i] = (not 0'u64)
  if r > 0:result.data[q] = ((1'u64 shl uint64(r)) - 1)

proc `not`[N:static[int]](a: StaticBitSet[N]): StaticBitSet[N] =
  result = initStaticBitSet1[N]()
  for i in 0..<a.data.len: result.data[i] = (not a.data[i]) and result.data[i]
proc `or`[N:static[int]](a, b: StaticBitSet[N]): StaticBitSet[N] =
  result = initStaticBitSet[N]()
  for i in 0..<a.data.len: result.data[i] = a.data[i] or b.data[i]
proc `and`[N:static[int]](a, b: StaticBitSet[N]): StaticBitSet[N] =
  result = initStaticBitSet[N]()
  for i in 0..<a.data.len: result.data[i] = a.data[i] and b.data[i]
proc `xor`[N:static[int]](a, b: StaticBitSet[N]): StaticBitSet[N] =
  result = initStaticBitSet[N]()
  for i in 0..<a.data.len: result.data[i] = a.data[i] xor b.data[i]

proc `$`[N:static[int]](a: StaticBitSet[N]):string =
  var
    q = N div BitWidth
    r = N mod BitWidth
  var v = newSeq[string]()
  for i in 0..<q: v.add(a.data[i].toBin(BitWidth))
  if r > 0: v.add(a.data[q].toBin(r))
  v.reverse()
  return v.join("")

proc any[N:static[int]](a: StaticBitSet[N]): bool = 
  var
    q = N div BitWidth
    r = N mod BitWidth
  for i in 0..<q:
    if a.data[i] != 0.uint64: return true
  if r > 0 and (a.data[^1] and setBits[uint64](r)) != 0.uint64: return true
  return false

proc all[N:static[int]](a: StaticBitSet[N]): bool =
  var
    q = N div BitWidth
    r = N mod BitWidth
  for i in 0..<q:
    if (not a.data[i]) != 0.uint64: return false
  if r > 0 and a.data[^1] != setBits[uint64](r): return false
  return true

proc `[]`[N:static[int]](b:StaticBitSet[N],n:int):int =
  assert 0 <= n and n < N
  let
    q = n div BitWidth
    r = n mod BitWidth
  return b.data[q][r]
proc `[]=`[N:static[int]](b:var StaticBitSet[N],n:int,t:int) =
  assert 0 <= n and n < N
  assert t == 0 or t == 1
  let
    q = n div BitWidth
    r = n mod BitWidth
  b.data[q][r] = t

proc `shl`[N:static[int]](a: StaticBitSet[N], n:int): StaticBitSet[N] =
  result = initStaticBitSet[N]()
  var r = int(n mod BitWidth)
  if r < 0: r += BitWidth
  let q = (n - r) div BitWidth
  let maskl = setBits[uint64](BitWidth - r)
  for i in 0..<a.data.len:
    let d = (a.data[i] and maskl) shl uint64(r)
    let i2 = i + q
    if 0 <= i2 and i2 < a.data.len: result.data[i2] = result.data[i2] or d
  if r != 0:
    let maskr = setBits[uint64](r) shl uint64(BitWidth - r)
    for i in 0..<a.data.len:
      let d = (a.data[i] and maskr) shr uint64(BitWidth - r)
      let i2 = i + q + 1
      if 0 <= i2 and i2 < a.data.len: result.data[i2] = result.data[i2] or d
  block:
    let r = a.N mod BitWidth
    if r != 0:
      let mask = not (setBits[uint64](BitWidth - r) shl uint64(r))
      result.data[^1] = result.data[^1] and mask
proc `shr`[N:static[int]](a: StaticBitSet[N], n:int): StaticBitSet[N] = a shl (-n)


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

const B = 4000
#const B = 15

proc calc(a,b:StaticBitSet[B]):StaticBitSet[B] =
  var
    a = a
    b = b
    i = B - 1
    j = B - 1
  while i >= 0 and a[i] == 0:i.dec
  while j >= 0 and b[j] == 0:j.dec
  assert(i >= 0 and j >= 0)
  if i < j:swap(a,b);swap(i,j)
  while true:
    # i > j
    for t in countdown(i - j, 0):
      if a[j+t] == 1:
        a = a xor (b shl t)
    while i >= 0 and a[i] == 0:
      i.dec
    if not a.any():return b
    if i < 0: return b
    swap(a,b)
    swap(i,j)

proc main() =
  var a = initStaticBitSet[B]()
  for i in 0..<N:
    var b = initStaticBitSet[B]()
    for j in 0..<A[i].len:
      if A[i][j] == '1':
        b[A[i].len - 1 - j] = 1
    if i == 0:
      a = b
    else:
      a = calc(a, b)
  var ai = B - 1
  while a[ai] == 0: ai.dec
  ans := Mint(0)
  x := initStaticBitSet[B]()
  for j in 0..<X.len:
    t := X.len - 1 - j
    if t < ai:
      break
    if X[j] == '1':
      # set 0
      ans += Mint(2)^(t-ai)
      if x[t] == 0:
        x = x xor (a shl (t - ai))
    else:
      if x[t] == 1:
        x = x xor (a shl (t - ai))
  var valid = true
  for i in 0..<X.len:
    if X[i] == '0' and x[X.len - 1 - i] == 1:
      valid = false
      break
    elif X[i] == '1' and x[X.len - 1 - i] == 0:
      break
  if valid: ans += 1
  echo ans
  return

main()

