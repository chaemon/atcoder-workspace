#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false
  result = ""
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
template inf(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

let EPS = 1e-9

block main:
  let A, B = nextInt()
  for p in 1..10000:
    if (p.float * 0.08 + EPS).int == A and (p.float * 0.1 + EPS).int == B:
      echo p;break main
  echo -1
  discard

