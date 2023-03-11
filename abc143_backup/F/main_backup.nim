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


proc solve(N:int, A:seq[int]) =
  let m = max(A)
  var max_count = 0
  for i in 0..<N:
    if A[i]==m: max_count += 1
  var s = initSet[int]()
  for i in 0..<N:s.incl(A[i])
  for K in 1..N:
    if K == 1:
      echo N
    elif K > s.len:
      echo 0
    else:
      var rest = N - max_count
      var u = rest div (K - 1)
      if u >= max_count:
        echo N div K
      else:
        echo u
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
  solve(N, A);
  return

main()
#}}}
