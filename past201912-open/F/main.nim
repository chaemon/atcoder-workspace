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

proc solve(S:string) =
  proc isUpperAscii(c:char):bool =
    'A'.ord <= c.ord and c.ord <= 'Z'.ord
  proc toLower(s:string):string =
    result = s
    result[0] = chr(result[0].ord - 'A'.ord + 'a'.ord)
    result[^1] = chr(result[^1].ord - 'A'.ord + 'a'.ord)
  proc toUpper(s:string):string =
    result = s
    result[0] = chr(result[0].ord - 'a'.ord + 'A'.ord)
    result[^1] = chr(result[^1].ord - 'a'.ord + 'A'.ord)
  var i = 0
  var v = newSeq[string]()
  while i < S.len:
    assert(S[i].isUpperAscii)
    var j = i + 1
    while j < S.len and not S[j].isUpperAscii:
      j += 1
    v.add(S[i..j].toLower)
    i = j + 1
  v.sort()
  w := newSeq[string]()
  for vi in v: w.add(vi.toUpper)
  echo w.join("")
  return

#{{{ main function
proc main() =
  var S = ""
  S = nextString()
  solve(S);
  return

main()
#}}}
