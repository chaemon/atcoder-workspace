#{{{ header
{.hints:off warnings:off.}
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
    let c = getchar()
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
macro dump*(x: typed): untyped =
  let s = x.toStrLit
  let r = quote do:
    debugEcho `s`, " = ", `x`
  return r
#}}}

#{{{ main function
proc main() =
  let N, Q = nextInt()
  var g = newSeqWith(N, newSeqWith(N, 0))
  proc write() =
    for i in 0..<N:
      for j in 0..<N:
        if i == j:
          stdout.write "N"
        else:
          stdout.write if g[i][j] == 0: "N" else: "Y"
      echo ""
  for q in 0..<Q:
    let t = nextInt()
    if t == 1:
      let a, b = nextInt() - 1
      g[a][b] = 1
    elif t == 2:
      var g2 = g
      let a = nextInt() - 1
      for x in 0..<N:
        if x == a: continue
        if g[x][a] == 1: g2[a][x] = 1
      swap(g, g2)
    else:
      var g2 = g
      let a = nextInt() - 1
      for x in 0..<N:
        if a == x: continue
        if g[a][x] == 1:
          for y in 0..<N:
            if y == a or y == x: continue
            if g[x][y] == 1:
              g2[a][y] = 1
      swap(g, g2)
  write()
  return

main()
#}}}
