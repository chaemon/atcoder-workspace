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

from sequtils import newSeqWith, allIt

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template newSeqWith*[T](lens: varargs[int]; init: T): untyped =
  static: assert(lens.allIt(it > 0))
  newSeqWithImpl(@lens, init, 1, lens.len)

proc reduce_consective[T](v:seq[T]): seq[(T,int)] =
  result = newSeq[(T,int)]()
  var i = 0
  while i < v.len:
    var j = i
    while j < v.len and v[i] == v[j]: j += 1
    result.add((v[i], j - i))
    i = j
  discard

proc solve(S:string) =
  var v = newSeq[int]()
  for i in 0..<S.len:
    var t = ord(S[i]) - ord('0')
    if i mod 2 == 1: t = (t + 1) mod 2
    v.add(t)
  var w = reduce_consective(v)
  var ans = 0
  var s = newSeq[(int,int)]()
#  echo v
#  echo w
  for p in w.mitems:
    ans += p[1] div 2
    p[1] = p[1] mod 2
    if p[1] == 0: continue
#    echo s
    assert(p[1] == 1)
    if s.len > 0:
      var q = s.pop()
      if p[0] == q[0]:
        q[1] += p[1]
        ans += q[1] div 2
        assert q[1] mod 2 == 0
      else:
        s.add(q)
        s.add(p)
    else:
      s.add(p)
  echo ans * 2
  return

#{{{ main function
proc main() =
  var S = ""
  S = nextString()
  solve(S);
  return

main()
#}}}
