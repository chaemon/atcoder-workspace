#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, options
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
    var c = getchar()
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
#}}}


#{{{ bitutils
proc popcount(n: int): int{.importc: "__builtin_popcount", nodecl.}
proc builtin_ctz(n: int): int{.importc: "__builtin_ctz", nodecl.}
proc llround(n: float): int{.importc: "llround", nodecl.}

proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if (b and (B(1) shl B(n))) == 0: 0 else: 1)
proc test[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc set[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc unset[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))
proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.unset(n)
  elif t == 1: b.set(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int = sizeof(B)):string =
  result = ""
  var n = n * 8
  for i in countdown(n-1,0):result &= $(b[i])
proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
#}}}

const MOD = 1_000_000_007

#{{{ ModInt[Mod]
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

type ModInt[Mod: static[int32]] = object
  v:int32
proc initModInt[T](a:T, Mod: static[int32]):ModInt[Mod] =
  when T is ModInt[Mod]:
    return a
  else:
    var a = int(a)
    a = a mod Mod
    if a < 0: a += Mod
    result.v = int32(a)
proc init[T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity(self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[T](a:ModInt[Mod], b:T):bool = a.v == initModInt(b, Mod).v
proc `!=`[T](a:ModInt[Mod], b:T):bool = a.v != initModInt(b, Mod).v
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
  self.v = int(self.v) * int(initModInt(a, Mod).v) mod Mod
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

proc decode(i,j:int):int = i * 5 + j

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)
const B = (1 shl 25)
#var dp:array[B, Mint]
var dp = newSeq[Mint](B)

proc solve(x:seq[seq[int]]) =
  var reserved = newSeqWith(26, none((int,int)))
  for i in 0..<5:
    for j in 0..<5:
      if x[i][j] > 0:
        reserved[x[i][j]] = some((i,j))
  for i in 0..<B: dp[i] = initMint(0)
  dp[0] = initMint(1)
  for b in 0..<B-1:
    if dp[b] == 0: continue
    let d = popcount(b) + 1
    if reserved[d].isSome:
      let (i,j) = reserved[d].get
      assert((b and (1 shl decode(i,j))) > 0)
      dp[b or (1 shl decode(i,j))] += dp[b]
    else:
      echo writeBits[int](b, 4)
      echo dp[b]
      echo ""
      for i in 0..<5:
        for j in 0..<5:
          let t = (1 shl decode(i,j))
          if (b and t) > 0: continue
          if x[i][j] > 0: continue
          let b2 = (b or t)
          if 0 < i and i < 4:
            let (s,t) = (decode(i-1,j), decode(i+1,j))
            if (b[s] == 0 and b[t] == 1) or (b[s] == 1 and b[t] == 0): continue
          if 0 < j and j < 4:
            let (s,t) = (decode(i,j-1), decode(i,j+1))
            if (b[s] == 0 and b[t] == 1) or (b[s] == 1 and b[t] == 0): continue
          echo "next: ", writeBits(b2, 4)
          dp[b2] += dp[b]
  echo dp[B - 1]
  return

#{{{ main function
proc main() =
  var x = newSeqWith(5, newSeqWith(5, 0))
  for i in 0..<5:
    for j in 0..<5:
      x[i][j] = nextInt()
  solve(x);
  return

main()
#}}}
