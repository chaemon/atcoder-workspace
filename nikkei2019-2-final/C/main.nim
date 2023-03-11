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

import future

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

proc calc(d, u: seq[int]):int=
  v := newSeq[int](d.len)
  tail := 0
  for i,di in d:
    assert i <= tail
    # i: 1, i + 1: 2, i + 2: 3, ..., i + di - 1: di
    while tail < i + di and tail < v.len:
      v[tail] = tail - i + 1
      tail += 1
  for i in 0..<v.len:



proc solve(H:int, W:int, K:int, x:seq[int], y:seq[int]) =
  var
    a = newSeqWith(H, newSeqWith(W, true))
    up = newSeqWith(H, newSeqWith(W, -1))
    down = newSeqWith(H, newSeqWith(W, -1))
  for i in 0..<K: a[x[i]][y[i]] = false
  proc inner(x, y: int): bool = 0 <= x and x < H and 0 <= y and y < W
  proc calcUp(x, y: int):int =
    if not inner(x,y): return 0
    if up[x][y] >= 0: return up[x][y]
    if not a[x][y]: up[x][y] = 0
    else:
      up[x][y] = calcUp(x - 1, y) + 1
    return up[x][y]
  proc calcDown(x, y: int):int =
    if not inner(x,y): return 0
    if down[x][y] >= 0: return down[x][y]
    if not a[x][y]: down[x][y] = 0
    else:
      down[x][y] = calcdown(x + 1, y) + 1
    return down[x][y]
  for x in 0..<H:
    for y in 0..<W:
      discard calcUp(x,y)
      discard calcDown(x,y)
  var tb = initTable[int,seq[(int,int)]]()
  for x in 0..<H:
    for y in 0..<W:
      tb[y - x].add((x, y))
  for k, v in tb.mpairs: v.sort()
  var val = newSeq[(seq[int], seq[int])]()
  for k,v in tb.mpairs:
    var a,b = newSeq[int]()
    for p in v:
      let (x,y) = p
      a.add(down[x][y])
      b.add(up[x][y])
    val.add((a, b))
  var ans = 0
  for p in val:
    let (d, u) = p
    ans.max=calc(d, u)
  echo ans
  return

#{{{ main function
proc main() =
  var H = 0
  H = nextInt()
  var W = 0
  W = nextInt()
  var K = 0
  K = nextInt()
  var x = newSeqWith(K, 0)
  var y = newSeqWith(K, 0)
  for i in 0..<K:
    x[i] = nextInt() - 1
    y[i] = nextInt() - 1
  solve(H, W, K, x, y);
  return

main()
#}}}

