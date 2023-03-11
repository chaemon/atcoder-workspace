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

var N:int
var s:string

proc solve() =
  proc test(S:var string):bool =
    for i in 1..N-2:
      var right = i + 1
      if s[i] == 'o':
        if S[i] == 'S':
          S[right] = if S[i-1] == 'S': 'S' else: 'W'
        else:
          S[right] = if S[i-1] == 'S': 'W' else: 'S'
      else:
        if S[i] == 'S':
          S[right] = if S[i-1] == 'S': 'W' else: 'S'
        else:
          S[right] = if S[i-1] == 'S': 'S' else: 'W'
    var tmp:char
    if s[N-1] == 'o':
      if S[N-1] == 'S':
        tmp = if S[N-2] == 'S': 'S' else: 'W'
      else:
        tmp = if S[N-2] == 'S': 'W' else: 'S'
    else:
      if S[N-1] == 'S':
        tmp = if S[N-2] == 'S': 'W' else: 'S'
      else:
        tmp = if S[N-2] == 'S': 'S' else: 'W'
    if tmp != S[0]: return false
    if s[0] == 'o':
      if S[0] == 'S':
        tmp = if S[N-1] == 'S': 'S' else: 'W'
      else:
        tmp = if S[N-1] == 'S': 'W' else: 'S'
    else:
      if S[0] == 'S':
        tmp = if S[N-1] == 'S': 'W' else: 'S'
      else:
        tmp = if S[N-1] == 'S': 'S' else: 'W'
    if tmp != S[1]: return false
    return true

  block:
    var S = '?'.repeat(N)
    S[0] = 'S'
    S[1] = 'S'
    if test(S):
      echo S;return
  block:
    var S = '?'.repeat(N)
    S[0] = 'S'
    S[1] = 'W'
    if test(S):
      echo S;return
  block:
    var S = '?'.repeat(N)
    S[0] = 'W'
    S[1] = 'S'
    if test(S):
      echo S;return
  block:
    var S = '?'.repeat(N)
    S[0] = 'W'
    S[1] = 'W'
    if test(S):
      echo S;return
  echo -1
  return

#{{{ input part
block:
  N = nextInt()
  s = nextString()
  solve()
#}}}
