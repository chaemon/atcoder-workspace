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
var t:seq[int]
var v:seq[int]

proc solve() =
  var left_max, right_max = newSeq[int](N + 1)
  left_max[0] = 0
  for i in 0..<N:
    var v_right: int
    if i == N - 1: v_right = 0
    else: v_right = v[i+1]
    left_max[i + 1] = min(v[i], v_right, left_max[i] + t[i])
  right_max[N] = 0
  for i in countdown(N - 1, 0):
    var v_left: int
    if i == 0: v_left = 0
    else: v_left = v[i-1]
    right_max[i] = min(v[i], v_left, right_max[i+1] + t[i])
  var
    ans = 0.0
    speed = 0.0
  for i in 0..<N:
    let left_speed = min(left_max[i], right_max[i]).float
    let right_speed = min(left_max[i+1], right_max[i+1]).float
#    dump(i)
#    dump(left_speed)
#    dump(right_speed)
    var
      t0 = v[i].float - left_speed
      t1 = v[i].float - right_speed
      t_mid: float
    if t0 + t1 > t[i].float:
#      echo "calc again"
      t0 = (t[i].float + right_speed - left_speed) / 2.0
      t1 = (t[i].float + left_speed - right_speed) / 2.0
      t_mid = 0.0
    else:
      t_mid = t[i].float - t0 - t1
    speed_next := speed + t0
    ans += (speed + speed_next) * t0 / 2.0
    speed = speed_next
    ans += speed * t_mid
    speed_next := speed - t1
    ans += (speed + speed_next) * t1 / 2.0
    speed = speed_next
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  t = newSeqWith(N, nextInt())
  v = newSeqWith(N, nextInt())
  solve()
#}}}
