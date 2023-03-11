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


proc solve(M:int, D:int) =
  proc is_seki(m,d:int): bool=
    let
      d1 = d mod 10
      d10 = d div 10
    if not(d1 >= 2): return false
    if not(d10 >= 2): return false
    if m == d1 * d10: return true
    else: return false
  var ans = 0
  for m in 1..M:
    for d in 1..D:
      if is_seki(m,d): ans += 1
  echo ans
  return

proc main() =
  var M = 0
  M = nextInt()
  var D = 0
  D = nextInt()
  solve(M, D);
  return

main()
