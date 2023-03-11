#{{{ header
{.hints:off warnings:off optimization:speed.}
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

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

#{{{ bitutils
import bitops

proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (b shr n) mod 2
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (1 shl (s.b - s.a + 1))
proc testBit[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc setBit[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc clearBit[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))

proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.clearBit(n)
  elif t == 1: b.setBit(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int) =
  var n = n * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
#proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
#proc countTrailingZeroBits(n:int):int =
#  for i in 0..<(8 * sizeof(n)):
#    if n[i] == 1: return i
#  assert(false)
#proc popcount(n:int):int =
#  result = 0
#  for i in 0..<(8 * sizeof(n)):
#    if n[i] == 1: result += 1
iterator subsets[B:SomeInteger](b:B):B =
  var v = newSeq[int]()
  for i in 0..<(8 * sizeof(B)):
    if b[i] == 1: v.add(i)
  var s = B(0)
  yield s
  while true:
    var found = false
    for i in v:
      if s[i] == 0:
        found = true
        s[i] = 1
        yield s
        break
      else:
        s[i] = 0
    if not found: break
#}}}

const MOD = 998244353
var H:int
var W:int
var A:seq[string]

#{{{ input part
proc solve()
block:
  H = nextInt()
  W = nextInt()
  A = newSeqWith(H, nextString())
#}}}

#{{{ ModInt[Mod]
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

type ModInt[Mod: static[int]] = object
  v:int32
proc initModInt[T](a:T, Mod: static[int]):ModInt[Mod] =
  when T is ModInt[Mod]:
    return a
  else:
    var a = a
    a = a mod Mod
    if a < 0: a += Mod
    result.v = a.int32
proc initModInt[T](a:T):ModInt[Mod] = initModInt(a, MOD)
proc init[T](self:ModInt[Mod], a:T):ModInt[Mod] = initModInt(a, Mod)
proc Identity(self:ModInt[Mod]):ModInt[Mod] = return initModInt(1, Mod)

proc `==`[T](a:ModInt[Mod], b:T):bool = a.v == a.init(b).v
proc `!=`[T](a:ModInt[Mod], b:T):bool = a.v != a.init(b).v
proc `-`(self:ModInt[Mod]):ModInt[Mod] =
  if self.v == 0.int32: return self
  else: return ModInt[Mod](v:MOD - self.v)
proc `$`(a:ModInt[Mod]):string = return $(a.v)

proc `+=`[T](self:var ModInt[Mod]; a:T):void =
  self.v += initModInt(a, Mod).v
  if self.v >= MOD: self.v -= MOD
proc `-=`[T](self:var ModInt[Mod],a:T):void =
  self.v -= initModInt(a, Mod).v
  if self.v < 0: self.v += MOD
proc `*=`[T](self:var ModInt[Mod],a:T):void =
  self.v = ((self.v.int * initModInt(a, Mod).v.int) mod MOD).int32
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

#{{{ combination
import sequtils

proc `/`(a, b:int):int = a div b

proc fact(T:typedesc, k:int):T =
  var fact_a{.global.} = @[getDefault(T).init(1)]
  if k >= fact_a.len:
    let sz_old = fact_a.len - 1
    let sz = max(sz_old * 2, k)
    fact_a.setlen(sz + 1)
    for i in sz_old + 1..sz: fact_a[i] = fact_a[i-1] * getDefault(T).init(i)
  return fact_a[k]
proc rfact(T:typedesc, k:int):T =
  var rfact_a{.global.} = @[getDefault(T).init(1)]
  if k >= rfact_a.len:
    let sz_old = rfact_a.len - 1
    let sz = max(sz_old * 2, k)
    rfact_a.setlen(sz + 1)
    rfact_a[sz] = getDefault(T).init(1) / T.fact(sz)
    for i in countdown(sz - 1, sz_old + 1): rfact_a[i] = rfact_a[i + 1] * getDefault(T).init(i + 1)
  return rfact_a[k]

proc inv(T:typedesc, k:int):T =
  return T.fact_a(k - 1) * T.rfact(k)

proc P(T:typedesc, n,r:int):T =
  if r < 0 or n < r: return getDefault(T).init(0)
  return T.fact(n) * T.rfact(n - r)
proc C(T:typedesc, p,q:int):T =
  if q < 0 or p < q: return getDefault(T).init(0)
  return T.fact(p) * T.rfact(q) * T.rfact(p - q)
#}}}

# 0: single row
# 1: single col
# 2: double row
# 3: double col
# 4: row and col

dp := Seq(H + 1, W + 1, 2, 2, 5, none(Mint))

proc calc(x, y, t:int, re, ce:bool):Mint =
  if x == 0:
    if ce:
      return initMint(2)^y
    else:
      return initMint(1)
  if y == 0:
    if re:
      return initMint(2)^x
    else:
      return initMint(1)
  let d = dp[x][y][re.int][ce.int][t]
  if d.isSome: return d.get
  var opt = if x == 1 and y == 2 and t == 3: true else: false
  s := initMint(0)
  if t == 0: # single row -> 1(only white)
    for k in 1..<x:
      s += Mint.C(x, k) * calc(x - k, y, 1, re, ce)
  elif t == 1: # single col -> 0(only white)
    for k in 1..<y:
      s += Mint.C(y, k) * calc(x, y - k, 0, re, ce)
  elif t == 2: # double row -> 1(x2), 3
    for k in 1..<x:
      for l in 1..x - k:
        if k + l == x:
          d := Mint.C(x, k)
          if ce:
            d *= initMint(2)^y
          s += d
        else:
          s += Mint.C(x, k) * Mint.C(x - k, l) * calc(x - k - l, y, 1, re, ce) * 2
          s += Mint.C(x, k) * Mint.C(x - k, l) * calc(x - k - l, y, 3, re, ce)
  elif t == 3: # double col -> 0(x2), 2
    for k in 1..<y:
      for l in 1..y - k:
        if k + l == y:
          d := Mint.C(y, k)
          if re:
            d *= initMint(2)^x
          s += d
        else:
          s += Mint.C(y, k) * Mint.C(y - k, l) * calc(x, y - k - l, 0, re, ce) * 2
          s += Mint.C(y, k) * Mint.C(y - k, l) * calc(x, y - k - l, 2, re, ce)
  elif t == 4: # row and col -> 0(only white), 1(only white), 4(only white)
    for k in 1..<x:
      for l in 1..<y:
        s += Mint.C(x, k) * Mint.C(y, l) * calc(x - k, y - l, 0, re, ce)
        s += Mint.C(x, k) * Mint.C(y, l) * calc(x - k, y - l, 1, re, ce)
        s += Mint.C(x, k) * Mint.C(y, l) * calc(x - k, y - l, 4, re, ce)
    # all black
    t := initMint(1)
    if re and ce:
      t *= initMint(2)^x + initMint(2)^y - initMint(1)
    elif re:
      t *= initMint(2)^x
    elif ce:
      t *= initMint(2)^y
    s += t # all black
  dp[x][y][re.int][ce.int][t] = s.some
  return s
proc calc(x, y:int, re, ce: bool):Mint =
  if x == 0:
    if ce:
      return initMint(2)^y
    else:
      return initMint(1)
  if y == 0:
    if re:
      return initMint(2)^x
    else:
      return initMint(1)
  result = initMint(0)
  result += calc(x, y, 0, re, ce) * 2
  result += calc(x, y, 1, re, ce) * 2
  result += calc(x, y, 2, re, ce)
  result += calc(x, y, 3, re, ce)
  result += calc(x, y, 4, re, ce) * 2

proc solve() =
  ans := initMint(0)
  for bh in 0..<2^H:
    h := newSeq[int]()
    for i in 0..<H:
      if bh.testBit(i): h.add(i)
    for bw in 0..<2^W:
      if bh == 0 and bw != 0: continue
      w := newSeq[int]()
      for j in 0..<W:
        if bw.testBit(j): w.add(j)
      valid := true
      for hi in h:
        var
          white = false
          black = false
        for wi in w:
          if A[hi][wi] == '#':
            black = true
          else:
            white = true
        if (not white) or (not black):
          valid = false
          break
      if not valid: continue
      for wi in w:
        var
          white = false
          black = false
        for hi in h:
          if A[hi][wi] == '#':
            black = true
          else:
            white = true
        if (not white) or (not black):
          valid = false
          break
      if not valid: continue
      var
        re = false
        ce = false
      if w.len > 0: re = true
      if h.len > 0: ce = true
      d := calc(H - h.len, W - w.len, re, ce)
      echo h, w, re.int, " ", ce.int, " ", d
      ans += d
  echo ans
  return

solve()
