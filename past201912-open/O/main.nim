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

# deduplicate {{{
proc deduplicate[T](s: openArray[T]): seq[T] =
  let h = s.toOrderedSet
  newSeq(result, h.len)
  var i = 0
  for el in h:
    result[i] = el
    inc(i)
# }}}

#{{{ Compress[T]
type Compress[T] = object
  xs: seq[T]
proc initCompress[T](xs:seq[T]):Compress[T] =
  result = Compress[T](xs:xs)
  result.build()
proc add[T](self:var Compress[T];t:T) =
  self.xs.add(t)
proc add[T](self:var Compress[T];v:seq[T]) =
  for t in v: self.add(t)
proc build[T](self:var Compress[T]) =
  self.xs.sort(cmp[T])
  self.xs = self.xs.deduplicate()
proc len[T](self:Compress[T]):int = self.xs.len
proc get[T](self:Compress[T], t:T):int =
  let i = self.xs.lowerBound(t)
  assert(self.xs[i] == t)
  return i
proc get[T](self:Compress[T], v:seq[T]):seq[int] =
  result = newSeq[int]()
  for t in v: result.add(self.get(t))
proc `[]`[T](self:Compress[T], k:int):T =
  return self.xs[k]
#}}}

proc solve(N:int, A:seq[seq[int]]) =
  v := newSeq[tuple[a,i,j:int]]()
  for i in 0..<N:
    for j in 0..<6:
      v.add((A[i][j], i, j))
  v.sort()
  e := newSeqWith(N, 1.0)
  emax := 1.0
  dp := newSeq[float](v.len)
  for i in countdown(v.len-1,0):
    dp[i] = emax
    # update e
    let (a, x, y) = v[i]
    e[x] += 1.0/6.0 * dp[a]
    emax.max=e[x]
  echo emax
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, newSeqWith(6, 0))
  var t = newSeq[int]()
  for i in 0..<N:
    for j in 0..<6:
      A[i][j] = nextInt()
      t.add(A[i][j])
  t.sort()
  tb := initTable[int,int]()
  for i,ti in t:
    tb[ti] = i
  for i in 0..<N:
    for j in 0..<6:
      A[i][j] = tb[A[i][j]]
  solve(N, A);
  return

main()
#}}}
