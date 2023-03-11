#{{{ header
import algorithm, sequtils, tables, future, macros, math, sets, strutils
 
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

proc upperBound(A:seq[int],v:int):int = 
  if A.len > 0:
    if A[0] > v:
      return 0
  var
    l = 0
    r = A.len
  while r - l > 1:
    var m = (l + r) div 2
    if v < A[m]: r = m
    else: l = m
  return r

proc write(a:varargs[Object]):void =
  discard

proc main():void =
  var
    N = nextInt()
    A = newSeqWith(N,nextInt())
    s = newSeq[int]()
  for a in A:
    var t = upperBound(s,-a)
    if t == s.len:
      s.add(-a)
    else:
      s[t] = -a
  echo s.len
  discard

main()

