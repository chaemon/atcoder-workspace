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
      when declaredInScope(`x`): `x` = `y`
      else:
        var `x` = `y`
      discardableId(`x`)
  else:
    return quote do:
      `x` = `y`
      discardableId(`x`)
#}}}

proc solve(N:int, D:int, M:seq[seq[int]]) =
  var dp = newSeqWith(N+1,int.infty)# right
  dp[0] = 0
  for i in 0..<D:
    let S = sum(M[i])
    var
      s = 0
      dp_to = newSeqWith(N+1, int.infty)
    var min_dp = int.infty
    for j in 0..N:
      min_dp.min=(dp[j])
      dp_to[j].min=(min_dp + abs(S - 2 * s))
      if j == N: break
      s += M[i][j]
    swap(dp, dp_to)
  echo dp.min
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var D = 0
  D = nextInt()
  var M = newSeqWith(D, newSeqWith(N, 0))
  for i in 0..<D:
    for j in 0..<N:
      M[i][j] = nextInt()
  solve(N, D, M);
  return

main()
#}}}
