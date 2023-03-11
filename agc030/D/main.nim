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
var N:int
var Q:int
var A:seq[int]
var X:seq[int]
var Y:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  Q = nextInt()
  A = newSeqWith(N, nextInt())
  X = newSeqWith(Q, 0)
  Y = newSeqWith(Q, 0)
  for i in 0..<Q:
    X[i] = nextInt() - 1
    Y[i] = nextInt() - 1
    if X[i] > Y[i]: swap(X[i], Y[i])
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

inv2 := initMint(1) / initMint(2)

proc test(Q:int) =
  var dp = ndSeq(N, N, 0)
#  for i in 0..<N:
#    for j in 0..<N:
#      if A[i] < A[j]: dp[i][j].inc
  var sum = 0
  for b in 0..<(1 shl Q):
    var A = A
    for q in 0..<Q:
      if (b and (1 shl q)) > 0:
        swap(A[X[q]], A[Y[q]])
    for i in 0..<N:
      for j in 0..<N:
        if A[i] < A[j]: dp[i][j].inc
    var ans = 0
    for i in 0..<N:
      for j in 0..<i:
        if A[i] < A[j]: ans.inc
#    echo A
#    echo ans
    sum += ans
  dump(sum)
  echo "test: "
  for i in 0..<N:
    for j in 0..<N:
      stdout.write dp[i][j], " "
    echo ""
  echo ""


proc main() =
  var dp = ndSeq(N, N, initMint(0))
  var t = 0
  for i in 0..<N:
    for j in 0..<N:
      if A[i] < A[j]: dp[i][j] += 1;t += 1
  var
    tmp_xi = newSeq[Mint](N)
    tmp_ix = newSeq[Mint](N)
    tmp_yi = newSeq[Mint](N)
    tmp_iy = newSeq[Mint](N)
  var prd = initMint(1)
  for q in 0..<Q:
    let (x, y) = (X[q], Y[q])
    let s = (dp[x][y] + dp[y][x]) * inv2
    dp[x][y] = s
    dp[y][x] = s
    for i in 0..<N:
      if i == x or i == y: continue
      dp[x][i] *= inv2
      dp[i][x] *= inv2
      dp[y][i] *= inv2
      dp[i][y] *= inv2
      tmp_xi[i] = dp[x][i]
      tmp_ix[i] = dp[i][x]
      tmp_yi[i] = dp[y][i]
      tmp_iy[i] = dp[i][y]
    for i in 0..<N:
      if i == x or i == y: continue
      dp[x][i] += tmp_yi[i]
      dp[i][x] += tmp_iy[i]
      dp[y][i] += tmp_xi[i]
      dp[i][y] += tmp_ix[i]
    prd *= 2
  ans := initMint(0)
  for i in 0..<N:
    for j in 0..<i:
      ans += dp[i][j]
  echo ans * prd
  return

main()
