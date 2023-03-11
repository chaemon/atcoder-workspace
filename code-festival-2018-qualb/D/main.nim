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


proc solve(N:int, M:int, q:int, x:seq[int], p:seq[int]) =
  var dp0, dp1 = newSeq[float](N+1)
  for i in 0..<M:
    



    
    swap(dp0,dp1)
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var q = 0
  q = nextInt()
  var x = newSeqWith(M, 0)
  var p = newSeqWith(M, 0)
  for i in 0..<M:
    x[i] = nextInt()
    p[i] = nextInt()
  solve(N, M, q, x, p);
  return

main()
#}}}
