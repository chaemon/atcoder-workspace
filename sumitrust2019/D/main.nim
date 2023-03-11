#{{{ header
{.hints:off checks:off.}
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
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
type someInteger = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger|someUnsignedInt: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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
#}}}


proc solve(N:int, S:string) =
  var a = newSeq[int]()
  for i,s in S: a.add(ord(s) - ord('0'))
  var next = newSeqWith(N, newSeqWith(10, 0))
  var tmp = newSeqWith(10, N)
  for i in countdown(N-1, 0):
    tmp[a[i]] = i
    for d in 0..<10:
      next[i][d] = tmp[d]
  proc isValid(D:seq[int]):bool =
    var i = 0
    for d in D:
      if i == N: return false
      i = next[i][d]
      if i == N: return false
      i += 1
    return true

  var ans = 0
  for a in 0..9:
    for b in 0..9:
      for c in 0..9:
        if isValid(@[a,b,c]): ans += 1
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var S = ""
  S = nextString()
  solve(N, S);
  return

main()
#}}}
