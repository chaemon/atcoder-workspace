#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future
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
type someInteger = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger|someUnsignedInt: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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

proc getDefault(T:typedesc): T = (var temp:T;temp)
proc getDefault[T](x:T): T = (var temp:T;temp)

proc Identity(self: seq[int]): seq[int] =
  return lc[i | (i <- 0..<self.len), int]
proc Inv(self: seq[int]): seq[int] =
  result = newSeq[int](self.len)
  for i in 0..<self.len:
    result[self[i]] = i

proc `*=`(a: var seq[int], b: seq[int]) =
  assert(a.len == b.len)
  var c = newSeq[int](a.len)
  for i in 0..<a.len:
    c[i] = a[b[i]]
  swap(a,c)

proc `^=`[T](self: var T, k:int) =
  var k = k
  var B = self.Identity()
  while k > 0:
    if (k and 1) > 0: B *= self
    self *= self;k = k shr 1
  self.swap(B)

proc solve(N:int, M:int, D:int, A:seq[int]) =
  var v = lc[i | (i <- 0..<N), int]
  for a in A: swap(v[a], v[a+1])
  v ^= D
  v = Inv(v)
  for i in 0..<N:echo v[i] + 1
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var M = 0
  M = nextInt()
  var D = 0
  D = nextInt()
  var A = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
  solve(N, M, D, A);
  return

main()
#}}}
