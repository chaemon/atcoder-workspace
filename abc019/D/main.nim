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
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)
#}}}

proc main():void =
  let N = nextInt()
  var max_val = -int.infty
  var max_u = -1
  for u in 1..<N:
    echo "?", " ", 0 + 1, " ", u + 1
    let t = nextInt()
    if max_val < t:
      max_val = t
      max_u = u
  max_val = -int.infty
  for u in 0..<N:
    if u == max_u: continue
    echo "?", " ", max_u + 1, " ", u + 1
    let t = nextInt()
    max_val.max=t
  echo "!", " ", max_val
  discard

main()

