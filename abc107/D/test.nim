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
template inf(T): untyped = 
  when T is float|float32|float64|BiggestFloat: T(Inf)
  elif T is int|int8|int16|int32|int64|BiggestInt: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)
#}}}

from strutils import addSep

type StringSeparator = distinct string

proc s*(s: string): StringSeparator =
  StringSeparator(s)

proc print*(xs: varargs[string, `$`]; sep: StringSeparator) =
  var msg = ""
  let s = string(sep)
  for x in xs:
    addSep(msg, sep = s)
    add(msg, x)
  echo msg

proc print*(xs: varargs[string, `$`]) =
  print(xs, sep = s" ")

print(1, 2, 3, 4)
print(1, 2, 3, 4, sep = s", ")
print("I", "have", "a", "pen")
print("I", "have", "a", "pen", sep = s"_")

proc main():void =
  discard

main()

