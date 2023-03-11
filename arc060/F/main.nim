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

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

const MOD = 1000000007
var w:string

#{{{ input part
proc main()
block:
  w = nextString()
#}}}

# RollingHash {{{
import sequtils

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
    hashed[i + 1] = mul(hashed[i], base) + s[i].ord.uint
    if hashed[i + 1] >= MOD.uint: hashed[i + 1] -= MOD
  return RollingHash(hashed: hashed, power: power)

proc `[]`(self: RollingHash; s:Slice[int]):uint =
  result = self.hashed[s.b+1] + MOD - mul(self.hashed[s.a], self.power[s.b-s.a+1])
  if result >= MOD.uint: result -= MOD

proc connect(self: RollingHash; h1, h2:uint, h2len:int):uint =
  result = mul(h1, self.power[h2len]) + h2
  if result >= MOD.uint: result -= MOD

proc LCP(self, b:RollingHash; l1, r1, l2, r2:int):int =
  var
    len = min(r1 - l1, r2 - l2)
    low = -1
    high = len + 1
  while high - low > 1:
    let mid = (low + high) div 2
    if self[l1..<l1 + mid] == b[l2..<l2 + mid]: low = mid
    else: high = mid
  return low
#}}}

proc main() =
  if w.toSet().len == 1:
    print w.len
    print 1
    return
  rh := initRollingHash(w)
  valid := Seq(w.len + 1, true)
  for l in 1..<w.len:
    s := rh[0..<l]
    t := s
    for j in countup(l * 2, w.len, l):
      t = rh.connect(t, s, l)
      if t == rh[0..<j]:
        valid[j] = false
      else:
        break
  for l in 1..<w.len:
    s := rh[w.len - l..<w.len]
    t := s
    for j in countup(l * 2, w.len, l):
      t = rh.connect(s, t, j - l)
      if t == rh[w.len - j..<w.len]:
        valid[w.len - j] = false
      else:
        break
  if valid[w.len]:
    print 1
    print 1
    return
  ans := 0
  for i in 1..<w.len:
    if valid[i]: ans += 1
  print 2
  print ans
  return

main()
