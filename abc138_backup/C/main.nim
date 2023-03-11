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


proc solve(N:int, v:var seq[float]) =
  v.sort(cmp[float])
  var s = v[0]
  for i in 1..<v.len:
    s = (s + v[i]) / 2.0
  echo s.formatFloat(ffDecimal,10)
  return

proc main() =
  var N = 0
  N = nextInt()
  var v = newSeqWith(N, 0.0)
  for i in 0..<N:
    v[i] = nextFloat()
  solve(N, v);
  return

main()
