#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)

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


proc solve(M:int, d:seq[int], c:seq[int]) =
  var
    D = sum(c)
    S = 0
  for i in 0..<M: S += d[i] * c[i]
  let
    T = S + D * 9
  var T2 = 1
  if S mod 9 == 0: T2 += 9
  else: T2 += S mod 9
  echo ((T - T2) div 9)
  return

#{{{ main function
proc main() =
  var M = 0
  M = nextInt()
  var d = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    d[i] = nextInt()
    c[i] = nextInt()
  solve(M, d, c);
  return

main()
#}}}
