#{{{ header
{.hints:off checks:off.}
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
type someSignedInt = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someInteger = someSignedInt|someUnsignedInt
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

proc sort[T](v: var seq[T]) = v.sort(cmp[T])

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

match := [0,2,5,5,4,5,6,3,7,6]

proc solve(N:int, M:int, A:seq[int]) =
  var dp = newSeqWith(N + 1, -int.inf)
  dp[0] = 0
  for n in 1..N:
    var d = -int.inf
    for a in A:
      var n2 = n - match[a]
      if n2 < 0: continue
      d.max=(dp[n2] + 1)
    dp[n] = d
  ans := ""
  k := dp[N]
  n := N
  while k > 0:
    var v = (-int.inf, -int.inf) # digit
    for a in A:
      var n2 = n - match[a]
      if n2 < 0 or dp[n2] < -int.inf: continue
      var p = (dp[n2], a)
      v.max=p
    ans = ans & (chr('0'.ord + v[1]))
    k -= 1
    n -= match[v[1]]
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var A = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
  solve(N, M, A);
  return

main()
#}}}
