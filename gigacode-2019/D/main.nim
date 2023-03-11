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


proc solve(H:int, W:int, K:int, V:int, A:seq[seq[int]]) =
  return

#{{{ main function
proc main() =
  var H = 0
  H = nextInt()
  var W = 0
  W = nextInt()
  var K = 0
  K = nextInt()
  var V = 0
  V = nextInt()
  var A = newSeqWith(H, newSeqWith(W, 0))
  for i in 0..<H:
    for j in 0..<W:
      A[i][j] = nextInt()
  solve(H, W, K, V, A);
  return

main()
#}}}
