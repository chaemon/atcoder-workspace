#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams, options
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

from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  static: assert(lens.allIt(it > 0))
  newSeqWithImpl(@lens, init, 1, lens.len)

proc solve(N:int, Z:int, W:int, a:seq[int]) =
  if N == 1: echo abs(a[0] - W);return
  dp := newSeqWith(N + 1, 2, none(int)) # opponet's index(previous), player
  proc calc(i, p: int):int =
    if dp[i][p].isSome: return dp[i][p].get
    if i == 0: assert(false)
    if p == 0:# turn X to maximize
      let Y = if i == N: W else: a[i]
      var ans = 0
      for j in countdown(i - 1, 1): # X takes j
        ans.max= calc(j, 1)
      ans.max= abs(Y - a[0])
      dp[i][p] = some(ans)
    else: # turn Y to minimize
      let X = if i == N: Z else: a[i]
      var ans = int.infty
      for j in countdown(i - 1, 1): # Y takes j
        ans.min= calc(j, 0)
      ans.min= abs(X - a[0])
      dp[i][p] = some(ans)
    return dp[i][p].get
  echo calc(N, 0)
  return


#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var Z = 0
  Z = nextInt()
  var W = 0
  W = nextInt()
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
  a.reverse()
  solve(N, Z, W, a);
  return

main()
#}}}
