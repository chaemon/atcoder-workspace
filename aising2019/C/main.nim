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
var S:seq[string]


proc solve() =
  var vis = newSeqWith(H, newSeqWith(W, false))
  for i in 0..<H:
    for j in 0..<W:
      if (i + j) mod 2 == 1:
        S[i][j] = if S[i][j] == '.': '#' else: '.'
  let dir = [[0,1], [1,0], [0,-1], [-1,0]]
  proc dfs(i,j:int, target:char):(int, int) =
    if vis[i][j]: return (0,0)
    vis[i][j] = true
    result = (0, 0)
    d := (i + j) mod 2
    if d == 0: result[0] += 1
    else: result[1] += 1
    for d in 0..<dir.len:
      let (i2, j2) = (i + dir[d][0], j + dir[d][1])
      if not (0 <= i2 and i2 < H and 0 <= j2 and j2 < W): continue
      if S[i2][j2] != target: continue
      t := dfs(i2, j2, target)
      result[0] += t[0]
      result[1] += t[1]
  ans := 0
  for i in 0..<H:
    for j in 0..<W:
      if vis[i][j]: continue
      d := dfs(i, j, S[i][j])
      ans += d[0] * d[1]
  echo ans
  return

#{{{ input part
block:
  H = nextInt()
  W = nextInt()
  S = newSeqWith(H, nextString())
  solve()
#}}}
