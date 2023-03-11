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


proc solve(N:int, B:seq[int]) =
  var ans = 0
  for i in 0..<B.len-1:
    ans += min(B[i], B[i+1])
  echo ans + B[0] + B[^1]
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var B = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    B[i] = nextInt()
  solve(N, B);
  return

main()
#}}}
