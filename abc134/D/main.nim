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
    N = nextInt()
    a = newSeqWith(N,nextInt())
    c = newSeq[int](N)
    M = 0
  for i in countdown(N-1,0):
    var
      d = i + 1
      s = 0
    for e in countup(d*2,N,d):
      s += c[e-1]
    c[i] = ((a[i] - s) mod 2 + 2) mod 2
    M += c[i]
  echo M
  for i in 0..<N:
    for j in 0..<c[i]:
      echo i + 1, " "
  echo "\n"
  discard

main()

