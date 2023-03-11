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

proc solve(N:int, S:seq[string]) =
  v := newSeq[int](5)
  for i in 0..<N:
    if S[i][0] == 'M': v[0] += 1
    elif S[i][0] == 'A': v[1] += 1
    elif S[i][0] == 'R': v[2] += 1
    elif S[i][0] == 'C': v[3] += 1
    elif S[i][0] == 'H': v[4] += 1
  ans := 0
  for i in 0..<5:
    for j in i+1..<5:
      for k in j+1..<5:
        ans += v[i]*v[j]*v[k]
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var S = newSeqWith(N, "")
  for i in 0..<N:
    S[i] = nextString()
  solve(N, S);
  return

main()
#}}}
