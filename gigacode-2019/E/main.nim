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

from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  static: assert(lens.allIt(it > 0))
  newSeqWithImpl(@lens, init, 1, lens.len)

let INF = float(1e+100)
let NO = "impossible"

proc solve(N:int, L:int, V_S:int, D_S:int, X:seq[int], V:seq[int], D:seq[int]) =
  var dp = newSeqWith(X.len, INF)
  dp[0] = float(0.0)
  for c in 0..<X.len - 1:# city
    var v, d:int
    if c == 0:
      v = V_S;d = D_S
    else:
      v = V[c-1];d = D[c-1]
    if dp[c] == INF:continue
    for c2 in c+1..<X.len:
      let diff = X[c2] - X[c]
      if diff > d: break
      dp[c2].min=(dp[c] + float(diff)/float(v))
  if dp[X.len-1] == INF: echo NO
  else: echo dp[X.len-1]

  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var L = 0
  L = nextInt()
  var V_S = 0
  V_S = nextInt()
  var D_S = 0
  D_S = nextInt()
  var X = newSeq[int]()
  var V = newSeq[int]()
  var D = newSeq[int]()
  var v = newSeq[(int,int,int)]()
  for i in 0..<N: v.add((nextInt(), nextInt(), nextInt()))
  v.sort()
  X.add(0)
  for i,a in v:
    X.add(a[0])
    V.add(a[1])
    D.add(a[2])
  X.add(L)
  solve(N, L, V_S, D_S, X, V, D)
  return

main()
#}}}

