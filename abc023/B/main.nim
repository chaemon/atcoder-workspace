#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

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

proc discardableId[T](x: T): T {.discardable.} =
  return x
macro `:=`(x, y: untyped): untyped =
  if (x.kind == nnkIdent):
    return quote do:
      when declaredInScope(`x`):
        `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
#}}}


proc solve(N:int, S:string) =
  var v = newSeq[string]()
  var s = "b"
  v.add(s)
  for i in 1..N:
    if i mod 3 == 1:
      s = "a" & s & "c"
    elif i mod 3 == 2:
      s = "c" & s & "a"
    else:
      s = "b" & s & "b"
    v.add(s)
  if S in v:
    echo((S.len - 1) div 2)
  else:
    echo -1
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var S = ""
  S = nextString()
  solve(N, S);
  return

main()
#}}}
