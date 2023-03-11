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

let a3_1 = @[
  "aa.",
  "..b",
  "..b"]

let a3_2 = @[
  "aab",
  "c.b",
  "cdd"]

let a4_3 = @[
  "aabc",
  "ddbc",
  "bcaa",
  "bcdd"]

let a5_3 = @[
  "aabee",
  "c.bff",
  "cddgg",
  "hij..",
  "hij.."
]

let a7_3 = @[
  "abc....",
  "abc....",
  "dd.e.ff",
  "g..ehh.",
  "g..ii.j",
  "..kkl.j",
  ".mm.lnn"]

proc solve(N:int) =
  if N == 1 or N == 2:
    echo -1;return
  a := newSeqWith(N, '.'.repeat(N))
  proc set(a:var seq[string], i, j:int, b:seq[string], base = 'a') =
    for ii in 0..<b.len:
      for jj in 0..<b[0].len:
        if b[ii][jj] != '.':
          a[i+ii][j+jj] = chr(base.ord - 'a'.ord + b[ii][jj].ord)
  var a6_3 = newSeqWith(6, '.'.repeat(6))
  a6_3.set(0,0,a3_1, 'a')
  a6_3.set(3,3,a3_1, 'a')
  a6_3.set(0,3,a3_2, 'c')
  a6_3.set(3,0,a3_2, 'c')
  if N == 7:
    a = a7_3
  elif N == 11:
    a.set(0,0,a5_3)
    a.set(5,5,a6_3)
  elif N mod 3 == 0:
    for i in countup(0, N - 1, 3):
      a.set(i, i, a_3_1)
  else:
    var p = 0
    while (N - p * 4) mod 5 != 0: p += 1
    let q = (N - p * 4) div 5
    assert(p >= 0 and q >= 0 and 4 * p + 5 * q == N)
    var s = 0
    for i in 0..<p:
      a.set(s, s, a4_3)
      s += 4
    for i in 0..<q:
      a.set(s, s, a5_3)
      s += 5
  for s in a:
    echo s
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  solve(N);
  return

main()
#}}}
