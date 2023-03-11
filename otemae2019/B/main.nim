#{{{ header
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header
else:
  {.hints:off checks:off}

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

proc solve(M:int, N:int, K:int, x:seq[int]) =
  var ans = 0
  for i in 1..M:
    var
      s = initSet[int]()
      y = 0
    for t in x:
      let d = abs(t - i)
      if d == 0: y += 1
      if 1 <= d and d <= K:
        s.incl(d)
    ans.max=(s.len + y)
  echo ans
  return

#{{{ main function
proc main() =
  var M = 0
  M = nextInt()
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  var x = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
  solve(M, N, K, x);
  return

main()
#}}}
