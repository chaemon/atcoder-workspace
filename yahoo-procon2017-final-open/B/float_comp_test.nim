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

# float comp {{{
const EPS = 1e-9

proc `==`(a,b:float):bool = system.`<`(abs(a - b), EPS)
proc `!=`(a,b:float):bool = system.`>`(abs(a - b), EPS)
proc `<`(a,b:float):bool = system.`<`(a + EPS, b)
proc `>`(a,b:float):bool = system.`>`(a, b + EPS)
proc `<=`(a,b:float):bool = system.`<`(a, b + EPS)
proc `>=`(a,b:float):bool = system.`>`(a + EPS, b)
# }}}

block main:
  echo 3.0 < 4.0

  discard

