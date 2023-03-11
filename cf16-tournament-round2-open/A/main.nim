#{{{ header
{.hints:off}
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

proc solve(x:int, p:int) =
  var fp = float(p)/100.0
  proc calc(x:int):float =
    assert x mod 2 == 0
    return float(x)/(2.0*fp)
  var ans = 0.0
  if x mod 2 == 0:
    ans = calc(x)
  else:
    ans =calc(x-1)*fp + calc(x+1)*(1.0-fp) + 1.0
  echo ans.formatFloat(ffDecimal,20)
  return

#{{{ main function
proc main() =
  var x = 0
  x = nextInt()
  var p = 0
  p = nextInt()
  solve(x, p);
  return

main()
#}}}
