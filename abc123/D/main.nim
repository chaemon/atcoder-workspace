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

proc merge(v, w: seq[int]):seq[int] =
  result = newSeq[int]()
  var i, j = 0
  while i < v.len or j < w.len:
    if i == v.len: result.add(w[j]); j += 1
    elif j == w.len: result.add(v[i]); i += 1
    else:
      if v[i] > w[j]: result.add(v[i]);i += 1
      else: result.add(w[j]);j += 1

proc solve(X:int, Y:int, Z:int, K:int, A:seq[int], B:seq[int], C:seq[int]) =
  v := newSeq[int]()
  for a in A:
    for b in B:
      v.add(a+b)
  v.sort()
  v.reverse()

  if v.len > K: v = v[0..<K]
  ans := newSeq[int]()
  for c in C:
    w := v
    for wi in w.mitems:
      wi += c
    ans = merge(ans, w)
    if ans.len > K: ans = ans[0..<K]
  for a in ans: echo a
  return

#{{{ main function
proc main() =
  var X = 0
  X = nextInt()
  var Y = 0
  Y = nextInt()
  var Z = 0
  Z = nextInt()
  var K = 0
  K = nextInt()
  var A = newSeqWith(X, 0)
  for i in 0..<X:
    A[i] = nextInt()
  var B = newSeqWith(Y, 0)
  for i in 0..<Y:
    B[i] = nextInt()
  var C = newSeqWith(Z, 0)
  for i in 0..<Z:
    C[i] = nextInt()
  solve(X, Y, Z, K, A, B, C);
  return

main()
#}}}
