#{{{ header
{.hints:off.}
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

proc solve(N:int, Q:int, D:seq[int], T:seq[int], L:seq[int], R:seq[int]) =
  s := 0
  v := @[0]
  for i in 0..<N:
    s -= D[i]
    v.add(s)
  v.reverse()
  for i in 0..<Q:
    echo v.lowerBound(R[i] - T[i] + 1) - v.lowerBound(L[i] - T[i])
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var Q = 0
  Q = nextInt()
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    D[i] = nextInt()
  var T = newSeqWith(Q, 0)
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, Q, D, T, L, R);
  return

main()
#}}}
