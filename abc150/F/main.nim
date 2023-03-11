#{{{ header
{.hints:off warnings:off.}
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

import sequtils

const MOD = 1000000007'u

type RollingHash = object
  hashed, power: seq[uint]

proc mul(a,b:uint):uint =
  return (a * b) mod MOD
#  let
#    x = a * b
#    xh = (x shr 32'u)
#    xl = x
#  var d, m:uint
#  asm """ "divl %4; \n\t" : "=a" (d), "=d" (m) : "d" (xh), "a" (xl), "r" (MOD));" """
#  return m

proc initRollingHash(s:string, base = 10007'u):RollingHash =
  var
    sz = s.len
    hashed = newSeqWith(sz + 1, 0'u)
    power = newSeqWith(sz + 1, 0'u)
  power[0] = 1'u
  for i in 0..<sz:
    power[i + 1] = mul(power[i], base);
    hashed[i + 1] = mul(hashed[i], base) + uint(s[i].ord)
    if hashed[i + 1] >= MOD: hashed[i + 1] -= MOD
  return RollingHash(hashed: hashed, power: power)

proc get(self: RollingHash; s:Slice[int]):uint =
  if s.b < s.a: return 0
  result = self.hashed[s.b+1] + MOD - mul(self.hashed[s.a], self.power[s.b-s.a+1])
  if result >= MOD: result -= MOD

proc connect(self: RollingHash; h1, h2:uint, h2len:int):uint =
  result = mul(h1, self.power[h2len]) + h2
  if result >= MOD: result -= MOD

proc LCP(self, b:RollingHash; l1, r1, l2, r2:int):int =
  var
    len = min(r1 - l1, r2 - l2)
    low = -1
    high = len + 1
  while high - low > 1:
    let mid = (low + high) div 2
    if self.get(l1..<l1 + mid) == b.get(l2..<l2 + mid): low = mid
    else: high = mid
  return low

var N:int
var a:seq[int]
var b:seq[int]

proc get(a, an, b:string, cand: seq[int]):seq[int] =
  result = newSeq[int]()
  rha := initRollingHash(a)
  rhan := initRollingHash(an)
  rhb := initRollingHash(b)
  hb := rhb.get(0..<N)
  for k in cand:
    ha := rha.connect(rha.get(k..<N), rha.get(0..<k), k)
    han := rhan.connect(rhan.get(k..<N), rhan.get(0..<k), k)
    if ha == hb or han == hb: result.add(k)

proc solve() =
  var cand = newSeq[int]()
  for k in 0..<N: cand.add(k)
  for t in 0..<30:
    sa := ""
    san := ""
    sb := ""
    for i in 0..<N:
      if (a[i] and (1 shl t)) > 0:sa.add('1');san.add('0')
      else: sa.add('0');san.add('1')
      if (b[i] and (1 shl t)) > 0:sb.add('1')
      else: sb.add('0')
    cand = get(sa, san, sb, cand)
  for k in cand:
    echo k, " ", (b[0] xor a[k])


  return

#{{{ main function
proc main() =
  N = nextInt()
  a = newSeqWith(N-1-0+1, nextInt())
  b = newSeqWith(N-1-0+1, nextInt())
  solve()
  return

main()
#}}}
