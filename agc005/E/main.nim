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


proc solve(N:int, X:int, Y:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int]) =
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var X = 0
  X = nextInt()
  var Y = 0
  Y = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
  var c = newSeqWith(N-1, 0)
  var d = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    c[i] = nextInt()
    d[i] = nextInt()
  solve(N, X, Y, a, b, c, d);
  return

main()
#}}}
