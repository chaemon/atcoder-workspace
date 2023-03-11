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



var N:int
var a:seq[int]

proc solve() =
  var ans = newSeq[int]()
  proc trim(i:int) =
    for j in countdown(N-1, i+1): ans.add(j)
    for j in countup(0, i - 1): ans.add(0)
  proc calc(a:seq[int]) =
    for j in countdown(N-1, a[^1]+1):ans.add(j)
    for i in countdown(a.len-2, 0):
      # a[i]..a[i+1]
      let d = (a[i] + a[i + 1]) div 2
      for j in countdown(d, a[i] + 1): ans.add(j)
    for i in 0..<a[0]:ans.add(0)
  var
    odd_sum = 0
    odd_index = newSeq[int]()
    even_sum = 0
    even_index = newSeq[int]()
    odd_max = -(10^10)
    odd_max_index = -1
    even_max = -(10^10)
    even_max_index = -1
  for i in 0..<N:
    if i mod 2 == 0:
      if even_max < a[i]:
        even_max = a[i]
        even_max_index = i
      if a[i] > 0:
        even_sum += a[i]
        even_index.add(i)
    else:
      if odd_max < a[i]:
        odd_max = a[i]
        odd_max_index = i
      if a[i] > 0:
        odd_sum += a[i]
        odd_index.add(i)
  if even_max <= 0 and odd_max <= 0:
    if even_max >= odd_max:
      echo even_max
      trim(even_max_index)
    else:
      echo odd_max
      trim(odd_max_index)
  elif even_max <= 0:
    echo odd_sum
    calc(odd_index)
  elif odd_max <= 0:
    echo even_sum
    calc(even_index)
  else:
    if even_sum >= odd_sum:
      echo even_sum
      calc(even_index)
    else:
      echo odd_sum
      calc(odd_index)
  echo ans.len
  for a in ans:
    echo a + 1
  return

#{{{ input part
N = nextInt()
a = newSeqWith(N, nextInt())
solve()
#}}}
