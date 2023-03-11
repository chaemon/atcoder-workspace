#{{{ header
{.hints:off checks:off.}
import algorithm, sequtils, tables, macros, math, sets, strutils, streams
when defined(MYDEBUG):
  import header

when (not (NimMajor <= 0)) or NimMinor >= 19:
  import sugar
else:
  import future
  proc sort[T](a:var seq[T]) = a.sort(cmp[T])

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(base:int = 0): int =
  scanf("%lld",addr result)
  result -= base
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString(): string =
  var get = false;result = ""
  while true:
    var c = getchar()
    if int(c) > int(' '): get = true;result.add(c)
    elif get: break
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template infty(T): untyped = ((T(1) shl T(sizeof(T)*8-2)) - 1)

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

var R:int
var C:int
var K:int
var N:int
var r:seq[int]
var c:seq[int]

proc solve() =
  var row2col = newSeq[seq[int]](R)
  for i in 0..<R: row2col[i] = newSeq[int]()
  for i in 0..<N: row2col[r[i]].add(c[i])
  var row_ct = newSeq[int](R)
  var col_ct = newSeq[int](C)
  var rev_colct = newSeq[int](C+1)
  for i in 0..<N: rowct[r[i]] += 1
  for i in 0..<N: colct[c[i]] += 1
  for i in 0..<C:
    rev_colct[colct[i]] += 1
  ans := 0
  for i in 0..<R:
    let t = K - row_ct[i]
    if 0 <= t and t < C: ans += rev_colct[t]
  for i in 0..<N:
    s := row_ct[r[i]] + col_ct[c[i]]
    if s == K:
      ans -= 1
    elif s - 1 == K:
      ans += 1
  echo ans
  return

#{{{ main function
proc main() =
  R = nextInt()
  C = nextInt()
  K = nextInt()
  N = nextInt()
  r = newSeqWith(N, 0)
  c = newSeqWith(N, 0)
  for i in 0..<N:
    r[i] = nextInt() - 1
    c[i] = nextInt() - 1
  solve()
  return

main()
#}}}
