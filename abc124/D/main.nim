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
type anyInt = int|int8|int16|int32|int64|BiggestInt
type anyUint = uint|uint8|uint16|uint32|uint64
type anyFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is anyFloat: T(Inf)
  elif T is anyInt|anyUint: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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

from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  static: assert(lens.allIt(it > 0))
  newSeqWithImpl(@lens, init, 1, lens.len)

proc reduceConsective[T](v:seq[T]): seq[(T,int)] =
  result = newSeq[(T,int)]()
  var i = 0
  while i < v.len:
    var j = i
    while j < v.len and v[i] == v[j]: j += 1
    result.add((v[i], j - i))
    i = j
  discard

proc solve(N:int, K:int, S:string) =
  v := reduceConsective(cast[seq[char]](S))
  s := newSeq[int]()
  s.add(0)
  for vi in v: s.add(s[^1] + vi[1])
  var ans = 0
  for i in 0..<v.len:
    var j = 0
    if v[i][0] == '0':
      j =  i + 2 * K
    else:
      j = i + 1 + 2 * K
    j.min=v.len
    ans.max=s[j] - s[i]
  echo ans

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var K = 0
  K = nextInt()
  var S = ""
  S = nextString()
  solve(N, K, S);
  return

main()
#}}}
