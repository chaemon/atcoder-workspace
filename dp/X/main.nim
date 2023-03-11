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

# newSeqWith {{{
from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

import future

var N:int
var w:seq[int]
var s:seq[int]
var v:seq[int]


proc solve() =
  a := newSeq[tuple[w, s, v:int]]()
  for i in 0..<N: a.add((w[i], s[i], v[i]))
  a.sort() do (a, b: tuple[w, s, v:int]) -> int:
    cmp(a.w + a.s, b.w + b.s)
  for i in 0..<N:
    w[i] = a[i].w
    s[i] = a[i].s
    v[i] = a[i].v
  var dp = newSeqWith(10001, -int.inf)
  dp[0] = 0
  ans := 0
  for i in 0..<N:
    var dp2 = dp
    for t in 0..s[i]:
      if dp[t] < 0: continue
      ans.max = dp[t] + v[i]
      let t2 = t + w[i]
      if t2 < dp.len:
        dp2[t2].max=dp[t] + v[i]
    swap(dp, dp2)
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  w = newSeqWith(N, 0)
  s = newSeqWith(N, 0)
  v = newSeqWith(N, 0)
  for i in 0..<N:
    w[i] = nextInt()
    s[i] = nextInt()
    v[i] = nextInt()
  solve()
#}}}
