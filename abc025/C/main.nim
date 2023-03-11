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
type SomeSignedInt = int|int8|int16|int32|int64|BiggestInt
type SomeUnsignedInt = uint|uint8|uint16|uint32|uint64
type SomeInteger = SomeSignedInt|SomeUnsignedInt
type SomeFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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


proc solve(b:seq[seq[int]], c:seq[seq[int]]) =
  var tb = initTable[seq[seq[int]], int]()
  proc calc(a:seq[seq[int]]):int =
    if a in tb: return tb[a]
    ct := 0
    for i in 0..<3:
      for j in 0..<3:
        if a[i][j] == 0: ct += 1
    if ct == 0:
      X := 0
      Y := 0
      for i in 0..<2:
        for j in 0..<3:
          if a[i][j] == a[i+1][j]: X += b[i][j]
          else: Y += b[i][j]
      for i in 0..<3:
        for j in 0..<2:
          if a[i][j] == a[i][j+1]: X += c[i][j]
          else: Y += c[i][j]
      return X - Y
    var a = a
    if ct mod 2 == 1:# 1
      result = -int.inf
      for i in 0..<3:
        for j in 0..<3:
          if a[i][j] != 0: continue
          a[i][j] = 1
          result.max= calc(a)
          a[i][j] = 0
    else:
      result = int.inf
      for i in 0..<3:
        for j in 0..<3:
          if a[i][j] != 0: continue
          a[i][j] = 2
          result.min= calc(a)
          a[i][j] = 0
    tb[a] = result
    return

  let s = calc(@[@[0,0,0],@[0,0,0],@[0,0,0]])
  t := 0
  for i in 0..<2:
    for j in 0..<3:
      t += b[i][j]
  for i in 0..<3:
    for j in 0..<2:
      t += c[i][j]
  echo((s + t) div 2)
  echo((t - s) div 2)
  return

#{{{ main function
proc main() =
  var b = newSeqWith(2, newSeqWith(3, 0))
  for i in 0..<2:
    for j in 0..<3:
      b[i][j] = nextInt()
  var c = newSeqWith(3, newSeqWith(2, 0))
  for i in 0..<3:
    for j in 0..<2:
      c[i][j] = nextInt()
  solve(b, c);
  return

main()
#}}}
