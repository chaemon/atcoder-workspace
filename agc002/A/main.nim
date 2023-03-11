#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

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
#}}}

proc solve(a:int, b:int) =
  if a > 0:
    echo "Positive"
  elif b >= 0:
    echo "Zero"
  else: # b < 0
    if (b - a + 1) mod 2 == 1:
      echo "Negative"
    else:
      echo "Positive"
  return

#{{{ main function
proc main() =
  var a = 0
  a = nextInt()
  var b = 0
  b = nextInt()
  solve(a, b);
  return

main()
#}}}
