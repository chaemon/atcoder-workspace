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
var A:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

main()

proc main() =
  flag := false
  for i in 0..<N:
    if A[i] != 0: flag = true
  if not flag:
    echo 0;return
  var v = newSeq[(int,int)]()
  for i in 0..<N:
    v.add((A[i], i))
  v.sort()
  s := newSeqWith(N, true)
  var
    i = 0
    t = 1
    ans = 1
  while i < N:
    var j = i
    while j < N and v[i][0] == v[j][0]: j += 1
    for k in i..<j:
      let d = v[k][1]
      if d > 0 and s[d - 1] and d < N - 1 and s[d + 1]:
        t += 1
      if (d == 0 or not s[d - 1]) and (d == N - 1 or not s[d + 1]):
        t -= 1
      s[d] = false
    ans.max=t
    swap(i, j)
  echo ans
  return
