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

proc solve(K:int, T:int, a:seq[int]) =
  var a = a
  a.sort()
  if a[^1] * 2 <= K:
    echo 0
  else:
    let r = K - a[^1]
    echo K - r * 2 - 1
  return

#{{{ main function
proc main() =
  var K = 0
  K = nextInt()
  var T = 0
  T = nextInt()
  var a = newSeqWith(T, 0)
  for i in 0..<T:
    a[i] = nextInt()
  solve(K, T, a);
  return

main()
#}}}
