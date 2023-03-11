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

#{{{ bitutils
proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (b shr n) mod 2
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (1 shl (s.b - s.a + 1))
proc test[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc set[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc unset[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))
proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.unset(n)
  elif t == 1: b.set(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int) =
  var n = n * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
#}}}



var N:int
var M_a:int
var M_b:int
var a:seq[int]
var b:seq[int]
var c:seq[int]

proc solve() =
  let
    N1 = N div 2
    N2 = N - N1
  ans := int.inf
  t1 := initTable[int,int]()
  for bt in 1..<2^N1:
    var
      sum = 0
      csum = 0
    for i in 0..<N1:
      if bt[i] == 1:
        csum += c[i];sum += M_a*b[i] - M_b*a[i]
    if sum == 0: ans .min= csum
    if sum notin t1: t1[sum] = int.inf
    t1[sum].min= csum
  t2 := initTable[int,int]()
  for bt in 1..<2^N2:
    var
      sum = 0
      csum = 0
    for i in 0..<N2:
      if bt[i] == 1:
        csum += c[i+N1];sum += M_a*b[i+N1] - M_b*a[i+N1]
    if sum == 0: ans .min= csum
    if sum notin t2: t2[sum] = int.inf
    t2[sum].min= csum
  for k,v in t1:
    if -k notin t2: continue
    ans.min= v + t2[-k]
  if ans == int.inf: echo -1
  else: echo ans
  return

#{{{ input part
block:
  N = nextInt()
  M_a = nextInt()
  M_b = nextInt()
  a = newSeqWith(N, 0)
  b = newSeqWith(N, 0)
  c = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
  solve()
#}}}
