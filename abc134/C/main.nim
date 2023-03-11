#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  while true:
    var c = getchar()
    if int(c) > int(' '):
      get = true
      result.add(c)
    else:
      if get: break
      get = false
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

proc main():void =
  var
    N = nextint()
    A = newSeqWith(N,nextInt())
    left = newSeqWith(N+1,-int.infty)
    right = newSeqWith(N+1,-int.infty)
  for i in countup(0,N-1):
    left[i+1] = max(left[i],A[i])
  for i in countdown(N-1,0):
    right[i] = max(right[i+1],A[i])
  for i in 0..N-1:
    echo max(left[i],right[i+1])
  discard

main()

