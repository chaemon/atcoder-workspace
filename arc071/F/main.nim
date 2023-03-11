#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
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

proc ndSeqImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], ndSeqImpl(lens, init, currentDimension + 1, lensLen))

template ndSeq*[T](lens: varargs[int]; init: T): untyped =
  ndSeqImpl(@lens, init, 1, lens.len)
#}}}

const MOD = 1000000007
var n:int

#{{{ input part
proc main()
block:
  n = nextInt()
#}}}

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

# CumulativeSum {{{
import sequtils

type CumulativeSum[T] = object
  pos:int
  data: seq[T]

proc initCumulativeSum[T]():CumulativeSum[T] = CumulativeSum[T](data: newSeqWith(1, T().init(0)), pos:0)
proc `[]=`[T](self: var CumulativeSum[T], k:int, x:T) =
  if k < self.pos: doAssert(false)
  if self.data.len < k + 2:
    self.data.setlen(k + 2)
  for i in self.pos+1..<k:
    self.data[i + 1] = self.data[i]
  self.data[k + 1] = self.data[k] + x
  self.pos = k

proc initCumulativeSum[T](data:seq[T]):CumulativeSum[T] =
  result = initCumulativeSum[T]()
  for i,d in data: result[i] = d

proc sum[T](self: CumulativeSum[T], k:int):T =
  if k < 0: return T().init(0)
  return self.data[min(k, self.data.len - 1)]
proc `[]`[T](self: CumulativeSum[T], s:Slice[int]):T =
  if s.a > s.b: return T().init(0)
  return self.sum(s.b + 1) - self.sum(s.a)
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

proc check(d:seq[int]):bool =
  for i in 0..<d.len - 1:
    v := -1
    for j in i + 1..i + d[i]:
      if j >= d.len: break
      if v == -1: v = d[j]
      elif v != d[j]: return false
  return true

proc naive(n:int) =
  b := n^n
  ans := 0
  a0 := 0
  a1 := 0
  a2 := 0
  for di in 0..<b:
    let d = toSeq(di, n, n).mapIt(it + 1)
    var t:int
    if d[^1] == 1: t = 0
    else:
      t = 1
      flag := true
      for i in 0..<n:
        if d[i] != 1:
          if i + 1 == d.len or d[i + 1] == 1 or d[i] == d[i + 1]:
            flag = false
          else:
            if d[i+1..^1].toSet().len != 1: flag = false
          break
      if flag: t = 2
    if d.check:
      ans.inc
      if t == 0:
        a0.inc
      elif t == 1:
        echo "found a1: ", d
        a1.inc
      elif t == 2:
        a2.inc
      else:
        doassert(false)
  echo "naive: "
  dump(a0)
  dump(a1)
  dump(a2)
  dump(ans)
#  echo "naive: ", ans, " ", a0

proc main() =
#  naive(n)
  dp := newSeqWith(n + 1, initMint(0))
  cs := initCumulativeSum[Mint]()
  dp[0] = initMint(1)
  for i in 0..2: cs[i] = dp[i]
  s := initMint(0)
  for i in 3..n:
    s += cs[0..i-4]
    s += dp[i - 3]
    dp[i] = s
    cs[i] = dp[i]
  ans := initMint(0)
  # end: 1
  a0 := initMint(1) # all 1
  for k in 0..n-2:
    a0 += dp[k] * (n - 1) * (n - 1 - k) # (length <= n - 2) (not 1) 1 1 1 1 1 1
  ans += a0
  a1 := initMint(0)
  for k in 0..n-1:
    a1 += dp[k] * (n - 1) * (n - k) # (length <= n - 1) k k k k k k k 
  for k in 0..n-2:
    a1 += dp[k] * (n - 1) * (n - 2) * (n - 1 - k) # (length <= n - 1) p k k k k k k 
  ans += a1
  print ans
  return

main()
