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


proc solve(N:int, A:seq[int], B:seq[int], C:seq[int]) =
  var
    prev = -1
    ans = 0
  for a in A:
    ans += B[a]
    if prev != -1 and prev + 1 == a:ans += C[prev]
    prev = a
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt() - 1
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    B[i] = nextInt()
  var C = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    C[i] = nextInt()
  solve(N, A, B, C);
  return

main()
#}}}
