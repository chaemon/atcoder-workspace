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

proc binomialTable(N:int):seq[seq[int]] =
  result = newSeqWith(N+1, newSeqWith(N+1, 0))
  for i in 0..N:
    for j in 0..i:
      if j == 0 or j == i: result[i][j] = 1
      else: result[i][j] = result[i - 1][j - 1] + result[i - 1][j]

var N:int
var A:int
var B:int
var v:seq[int]

proc solve() =
  binom := binomialTable(N)
  v.sort()
  v.reverse()
  m := -1
  num := 0
  ans := 0
  for c in A..B:
    s := v[0..<c].sum
    if m * c < s * num: # m < a
      m = s
      num = c
      ans = 0
    if m * c == s * num: # m <= a
      n := 0
      r := 0
      for i in 0..<N:
        if v[c-1] == v[i]:
          n += 1
          if i < c:
            r += 1
      ans += binom[n][r]
  echo m.float / num.float
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  A = nextInt()
  B = nextInt()
  v = newSeqWith(N, nextInt())
  solve()
#}}}
