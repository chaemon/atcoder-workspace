#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%intd",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if int(c) > int(' '):
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

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

proc toStr[T](v:T):string =
  proc `$`[T](v:seq[T]):string =
    v.mapIt($it).join(" ")
  return $v

proc print0(x: varargs[string, toStr]; sep:string):string{.discardable.} =
  result = ""
  for i,v in x:
    if i != 0: addSep(result, sep = sep)
    add(result, v)
  result.add("\n")
  stdout.write result

var print:proc(x: varargs[string, toStr])
print = proc(x: varargs[string, toStr]) =
  discard print0(@x, sep = " ")
#}}}

#{{{ Slice
proc len[T](self: Slice[T]):int = (if self.a > self.b: 0 else: self.b - self.a + 1)
proc empty[T](self: Slice[T]):bool = self.len == 0

proc `<`[T](p, q: Slice[T]):bool = return if p.a < q.a: true elif p.a > q.a: false else: p.b < q.b
proc intersection[T](p, q: Slice[T]):Slice[T] = max(p.a, q.a)..min(p.b, q.b)
proc union[T](v: seq[Slice[T]]):seq[Slice[T]] =
  var v = v
  v.sort(cmp[Slice[T]])
  result = newSeq[Slice[T]]()
  var cur = -T.inf .. -T.inf
  for p in v:
    if p.empty: continue
    if cur.b + 1 < p.a:
      if cur.b != -T.inf: result.add(cur)
      cur = p
    elif cur.b < p.b: cur.b = p.b
  if cur.b != -T.inf: result.add(cur)
proc `in`[T](s:Slice[T], x:T):bool = s.contains(x)
proc `*`[T](p, q: Slice[T]):Slice[T] = intersection(p,q)
proc `+`[T](p, q: Slice[T]):seq[Slice[T]] = union(@[p,q])
#}}}

import lists

var N:int
var A:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

import future

#{{{ findFirst(f, a..b), findLast(f, a..b)
proc findFirst(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): r = m
    else: l = m
  return r
proc findLast(f:(int)->bool, s:Slice[int]):int =
  var (l, r) = (s.a, s.b + 1)
  if not f(l): return -1
  while r - l > 1:
    let m = (l + r) div 2
    if f(m): l = m
    else: r = m
  return l
#}}}

proc `$`[S,T](p:(S,T)):string = "(" & $p[0] & "," & $p[1] & ")"

proc f(K:int):bool =
  if K == 0: return false
  if K == 1:
    for i in 0..<N-1:
      if A[i] >= A[i + 1]: return false
    return true
  type T = tuple[s:Slice[int],v:int]
  lst := initDoublyLinkedList[T]()
  var right = 0
  for t in lst: echo t
  for i in 0..<N:
    var j = A[i] - 1
    var v:int
    if right <= j:
      nd := newDoublyLinkedNode[T]((right..j, 0))
      lst.append(nd)
    else:
      while true:
        nd := lst.tail
        if j notin nd.value.s: lst.remove(nd)
        else: break
      nd := lst.tail
      l := nd.value.s.a
      nd.value.s = l..j
      # add 1 to j
      while true:
        nd := lst.tail
        doAssert nd.value.s.b == j
        if nd.value.v == K - 1:
          if j == 0: return false
          l := nd.value.s.a
          v := nd.value.v
          if l == j:
            lst.remove(nd)
          else:
            doAssert false
          j -= 1
        else:
          l := nd.value.s.a
          if l == j:
            nd.value.v += 1
          else:
            nd.value.s = l..j-1
            lst.append(newDoublyLinkedNode[T]((j..j, nd.value.v + 1)))
          break
    right = j + 1
  return true

proc main() =
  echo f.findFirst(0..N+1)
#  echo f(2)
#  echo f.findFirst(0..10)
#  echo f(1)
  return

main()
