#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
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
#}}}

let MOD = 5

proc solve(P:int, Q:int, L:int, R:int) =
  return

#{{{ main function
proc main() =
  var P = 0
  P = nextInt()
  var Q = 0
  Q = nextInt()
  var L = 0
  L = nextInt()
  var R = 0
  R = nextInt()
  solve(P, Q, L, R);
  return

main()
#}}}
