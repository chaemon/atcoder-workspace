#{{{ header
{.hints:off checks:off.}
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
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type someInteger = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger|someUnsignedInt: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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

const MOD = 1000000007

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

#{{{ toInt(seq[int], b = 10), toSeq(n: int, b = 10, min_digit)
proc toInt(d: seq[int], b = 10):int =
  result = 0
  var p = 1
  for di in d:
    result += p * di
    p *= b
proc toSeq(n: int, b = 10, min_digit = -1):seq[int] =
  result = newSeq[int]()
  var n = n
  while n > 0:result.add(n mod b); n = n div b
  if min_digit >= 0:
    while result.len < min_digit: result.add(0)
#}}}

type Mint = ModInt[Mod]
proc initMint[T](a:T):ModInt[Mod] = initModInt(a, Mod)

proc solve(N:int, K:int) =
  var n = newSeqWith(1, initMint(0))
  var s = newSeqWith(1, initMint(0))
  n[0] = initMint(1)
  for i in countdown(N, 1):
    # i-th element
#    let l = n.len + n.len div i + 1
    let l = n.len
    var n2 = newSeqWith(l, initMint(0))
    var s2 = newSeqWith(l, initMint(0))
    for t in 0..<n.len:
      # sum: t
      for p in 0..K:
        # starting with p
        if p <= i:
          var m:int
          let K = t - (i - p)
          if K < 0: m = 0
          else: m = K div i + 1
          if n2.len <= t + m:
            n2.setlen(t + m + 1)
            s2.setlen(t + m + 1)
          n2[t + m] += n[t]
          s2[t + m] += n[t] * p + s[t]
        else:
          n2[t] += n[t]
          s2[t] += n[t] * p + s[t]
    swap(n, n2)
    swap(s, s2)
  ans := initMint(0)
  for i in 0..<n.len:
    ans += s[i] - n[i] * i
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  solve(N, K);
  return

main()
#}}}
