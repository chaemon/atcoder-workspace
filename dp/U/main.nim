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
proc builtin_ctz(n:int):int =
  for i in 0..<(8 * sizeof(n)):
    if n[i] == 1: return i
  assert(false)
proc builtin_popcount(n:int):int =
  result = 0
  for i in 0..<(8 * sizeof(n)):
    if n[i] == 1: result += 1
#}}}

var N:int
var a:seq[seq[int]]

proc solve() =
  var h = newSeqWith(1 shl N, 0)
  for b in 0..<(1 shl N):
    v := newSeq[int]()
    for i in 0..<N:
      if b[i] == 1:
        v.add i
    s := 0
    for i,p in v:
      for j in i+1..<v.len:
        q := v[j]
        s += a[p][q]
    h[b] = s
  dp := newSeqWith(1 shl N, -int.inf)
  dp[0] = 0
  for b in 0..<(1 shl N)-1:
    if dp[b] == -int.inf: continue
    v := newSeq[int]()
    for i in 0..<N:
      if b[i] == 0: v.add(i)
    b2 := b
    flag := false
    while true:
      dp[b2] .max= dp[b] + h[b2 xor b]
      for i in 0..<v.len:
        if b2[v[i]] == 0:
          b2[v[i]] = 1
          for j in 0..<i: b2[v[j]] = 0
          break
        if i == v.len - 1: flag = true
      if flag: break
  echo dp[(1 shl N) - 1]
  return

#{{{ input part
block:
  N = nextInt()
  a = newSeqWith(N, newSeqWith(N, nextInt()))
  solve()
#}}}
