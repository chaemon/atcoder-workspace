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

const MOD = 1000000007
var N:int
var K:int
var a:seq[int]

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

# CumulativeSum (Imos)  initDualCumulativeSum(int or seq[T]){{{
import sequtils

type DualCumulativeSum[T] = object
  pos: int
  data: seq[T]

proc initDualCumulativeSum[T](sz:int = 100):DualCumulativeSum[T] = DualCumulativeSum[T](data: newSeqWith(sz, getDefault(T)), pos: -1)
proc initDualCumulativeSum[T](a:seq[T]):DualCumulativeSum[T] =
  var data = a
  data.add(getDefault(T))
  for i in 0..<a.len:
    data[i + 1] -= a[i]
  return DualCumulativeSum[T](data: data, pos: -1)
proc add[T](self: var DualCumulativeSum[T], s:Slice[int], x:T) =
  assert(self.pos < s.a)
  if s.a > s.b: return
  if self.data.len <= s.b + 1:
    self.data.setlen(s.b + 1 + 1)
  self.data[s.a] += x
  self.data[s.b + 1] -= x

proc `[]`[T](self: var DualCumulativeSum[T], k:int):T =
  if k < 0: return getDefault(T)
  if self.data.len <= k:
    self.data.setlen(k + 1)
  while self.pos < k:
    self.pos += 1
    if self.pos > 0: self.data[self.pos] += self.data[self.pos - 1]
  return self.data[k]
#}}}

proc solve() =
  var dp = @[initMint(1)]
  for i in 0..<N:
    let L = min(K + 1, dp.len + a[i])
    cs := initDualCumulativeSum[Mint](L)
    for j in 0..<dp.len:
      cs.add(j..min(K, j+a[i]), dp[j])
    var dp2 = newSeq[Mint]()
    for j in 0..<L:
      dp2.add(cs[j])
    swap(dp, dp2)
  if dp.len < K + 1:
    echo 0
  else:
    echo dp[K]

  return

#{{{ input part
block:
  N = nextInt()
  K = nextInt()
  a = newSeqWith(N, nextInt())
  solve()
#}}}
