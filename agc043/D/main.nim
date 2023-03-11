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

var N:int
var M:int

#{{{ input part
proc main()
block:
  N = nextInt()
  M = nextInt()
#}}}

var MOD:int

#{{{ ModInt
proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

type ModInt = object
  v:int32
proc initModInt[T](a:T):ModInt =
  when T is ModInt:
    return a
  else:
    var a = a
    if MOD > 0:
      a = a mod MOD
      if a < 0: a += MOD
    result.v = a.int32
proc init[T](self:ModInt, a:T):ModInt = initModInt(a)
proc Identity(self:ModInt):ModInt = return initModInt(1)

proc `==`[T](a:ModInt, b:T):bool = a.v == a.init(b).v
proc `!=`[T](a:ModInt, b:T):bool = a.v != a.init(b).v
proc `-`(self:ModInt):ModInt =
  if self.v == 0.int32: return self
  else: return ModInt(v:MOD.int32 - self.v)
proc `$`(a:ModInt):string = return $(a.v)

proc `+=`[T](self:var ModInt; a:T):void =
  self.v += initModInt(a).v
  if self.v >= MOD: self.v -= MOD.int32
proc `-=`[T](self:var ModInt,a:T):void =
  self.v -= initModInt(a).v
  if self.v < 0: self.v += MOD.int32
proc `*=`[T](self:var ModInt,a:T):void =
  self.v = ((self.v.int * initModInt(a).v.int) mod MOD).int32
proc `^=`(self:var ModInt, n:int) =
  var (x,n,a) = (self,n,self.Identity)
  while n > 0:
    if (n and 1) > 0: a *= x
    x *= x
    n = (n shr 1)
  swap(self, a)
proc inverse(x:int):ModInt =
  var (a, b) = (x, MOD)
  var (u, v) = (1, 0)
  while b > 0:
    let t = a div b
    a -= t * b;swap(a,b)
    u -= t * v;swap(u,v)
  return initModInt(u)
proc `/=`[T](a:var ModInt,b:T):void = a *= initModInt(b).v.inverse()
proc `+`[T](a:ModInt,b:T):ModInt = result = a;result += b
proc `-`[T](a:ModInt,b:T):ModInt = result = a;result -= b
proc `*`[T](a:ModInt,b:T):ModInt = result = a;result *= b
proc `/`[T](a:ModInt,b:T):ModInt = result = a; result /= b
proc `^`(a:ModInt,b:int):ModInt = result = a; result ^= b
#}}}

type Mint = ModInt
proc initMint[T](a:T):ModInt = initModInt(a)

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
proc H(T: typedesc, n,r:int):T =
  if n < 0 or r < 0: return getDefault(T).init(0)
  return if r == 0: T(1) else: T.C(n + r - 1, r)
#}}}

proc calc(a:seq[seq[int]]):seq[int] =
  var ai = newSeq[int](a.len)
  result = newSeq[int]()
  while true:
    v := newSeq[(int,int)]()
    for i in 0..<a.len:
      if ai[i] < a[i].len:
        v.add((a[i][ai[i]], i))
    if v.len == 0: break
    v.sort()
    let i = v[0][1]
    result.add(v[0][0])
    ai[i].inc
  echo result

proc naive() =
  a := [0, 1, 2, 3, 4, 5]
  st := initSet[seq[int]]()
  var t0, t1, t2, t3: int
  while true:
    w := calc(@[a[0..<3], a[3..<6]])
    st.incl(w)
    let v = a[3..<6]
    if v[0] < v[1] and v[1] < v[2]:
      t0.inc
    elif v[0] < v[1] and v[1] > v[2]:
      t1.inc
    elif v[0] > v[1] and v[0] > v[2]:
      t2.inc
    elif v[2] > v[0] and v[0] > v[1]:
      t3.inc
    else:
      assert false
    if not a.nextPermutation: break
  echo t0, " ", t1, " ", t2, " ", t3
  echo st.len

proc main() =
#  naive()
  MOD = M
  ans := initMint(0)
  for A in 0..N:
    for B in 0..N - A:
      d := Mint.C(3*N, 3*A)*Mint.fact(3*A)/(initMint(3)^A*Mint.fact(A)) * Mint.C(3*N - 3*A, 2*B)*Mint.fact(2*B)/(Mint.fact(2)^B*Mint.fact(B))
#      echo A, " ", B, " ", d
      ans += d
  echo ans
  return

main()
