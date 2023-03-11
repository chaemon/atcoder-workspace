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
  let A, B, C = nextFloat()
  proc f(t:float):float = A * t + B * sin(C * t * PI)
  var (l, r) = (0.0, 500.0)
  assert(f(l) < 100.0 and f(r) > 100.0)
  while abs(f(l) - 100.0) > 1e-9:
    let m = (l + r) * 0.5
    if f(m) < 100.0: l = m
    else: r = m
  assert(abs(f(l) - 100.0) < 1e-6)
  echo l
  discard

main()

