#{{{ header
{.hints:off}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

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

var
  N:int
  A:seq[string]

proc test() =
  var ct = 0
  proc f(a:seq[int]) =
    ct.inc
    echo ct
    echo a
    var c:int
    if a.len == 0:
      c = 0
    else:
      c = a[^1] + 1
    var a = a
    while a.len < 20:
      a.add(c)
      f(a)
  f(@[])


proc solve(N:int, A:seq[string]) =
  test()
  return

#{{{ main function
proc main() =
  N = nextInt()
  A = newSeqWith(2*N, nextString())
  solve(N, A)
  return

main()
#}}}
