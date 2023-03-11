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
#}}}


proc solve(a:float, b:float, x:float) =
  var theta = 0.0
  if x <= a * a * b / 2.0:
    let d = x*2.0/(a*b)
    theta = arctan(b/d)
  else:
    let d = (a * a * b - x)*2.0/(a*a)
    theta = PI/2.0 - arctan(a/d)
  echo theta/PI*180.0
  return

#{{{ main function
proc main() =
  var a = 0
  a = nextInt()
  var b = 0
  b = nextInt()
  var x = 0
  x = nextInt()
  solve(a.float, b.float, x.float);
  return

main()
#}}}
