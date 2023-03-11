#{{{ header
{.hints:off warnings:off optimization:speed.}
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

var H:int
var W:int
var N:int
var a:seq[int]
var b:seq[int]

#{{{ default-table
proc getDefault(T:typedesc): T =
  when T is string: ""
  elif T is seq: @[]
  else:
    (var temp:T;temp)

proc getDefault[T](x:T): T = getDefault(T)

import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, getDefault(B))
  tables.`[]`(self, key)
#}}}

proc solve() =
  tb := initTable[(int, int),int]()
  for i in 0..<N:
    for s in 0..<3:
      let x = a[i] - s
      if not (0 <= x and x < H - 2): continue
      for t in 0..<3:
        let y = b[i] - t
        if not (0 <= y and y < W - 2): continue
        tb[(x,y)] += 1
  ans := newSeq[int](10)
  for k,v in tb:
    ans[v] += 1
  ans[0] = (H - 2) * (W - 2) - ans.sum
  for i in 0..9:
    echo ans[i]
  return

#{{{ input part
block:
  H = nextInt()
  W = nextInt()
  N = nextInt()
  a = newSeqWith(N, 0)
  b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve()
#}}}
