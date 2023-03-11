#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

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

proc sort[T](a:var seq[T]) = a.sort(cmp[T])

template `:=`(a, b: untyped): untyped =
  when declaredInScope a:
    a = b
  else:
    var a = b
  when not declared seiuchi:
    proc seiuchi(x: auto): auto {.discardable.} = x
  seiuchi(x = b)
#}}}


proc solve(N:int, L:seq[int]) =
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var L = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
  solve(N, L);
  return

main()
#}}}
