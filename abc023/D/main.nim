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

proc findFirst(f:(int)->bool, l, r:int):int =
  var (l, r) = (l, r)
  if f(l): return l
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r

proc solve(N:int, H:seq[int], S:seq[int]) =
  proc calc(score: int):bool =
    v := newSeq[int]()
    for i in 0..<N:
      if score < H[i]: return false
      v.add((score - H[i]) div S[i])
    v.sort
    for t in 0..<N:
      if v[t] < t: return false
    return true
  echo findFirst(calc, 0, int(1000000000000000000))

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var H = newSeqWith(N, 0)
  var S = newSeqWith(N, 0)
  for i in 0..<N:
    H[i] = nextInt()
    S[i] = nextInt()
  solve(N, H, S);
  return

main()
#}}}
