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


proc solve(N:int, X:seq[int], P:seq[int], Q:int, a:seq[int], b:seq[int]) =
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var X = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    P[i] = nextInt()
  var Q = 0
  Q = nextInt()
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, X, P, Q, a, b);
  return

main()
#}}}
