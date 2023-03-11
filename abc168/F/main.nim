#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar, deques
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextFloat(): float = scanf("%lf",addr result)
proc nextString[F](f:F): string =
  var get = false
  result = ""
  while true:
#    let c = getchar()
    let c = f.readChar
    if c.int > ' '.int:
      get = true
      result.add(c)
    elif get: return
proc nextInt[F](f:F): int = parseInt(f.nextString)
proc nextFloat[F](f:F): float = parseFloat(f.nextString)
proc nextString():string = stdin.nextString()

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is SomeFloat: T(Inf)
  elif T is SomeInteger: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
  else: assert(false)

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

template SeqImpl(lens: seq[int]; init; d, l: static[int]): auto =
  when d == l:
    when init is typedesc: newSeq[init](lens[d - 1])
    else: newSeqWith(lens[d - 1], init)
  else: newSeqWith(lens[d - 1], SeqImpl(lens, init, d + 1, l))

template Seq(lens: varargs[int]; init): auto = SeqImpl(@lens, init, 1, lens.len)

template ArrayImpl(lens: varargs[int]; init: typedesc; d, l: static[int]): typedesc =
  when d == l: array[lens[d - 1], init]
  else: array[lens[d - 1], ArrayImpl(lens, init, d + 1, l)]

template ArrayFill(a, val): void =
  when a is array:
    for v in a.mitems: ArrayFill(v, val)
  else:
    a = val
  discard

template Array(lens: varargs[int]; init): auto =
  when init is typedesc:
    ArrayImpl(@lens, init, 1, lens.len).default
  else:
    var a:ArrayImpl(@lens, typeof(init), 1, lens.len)
    ArrayFill(a, init)
    a
# }}}

var N:int
var M:int
var A:seq[int]
var B:seq[int]
var C:seq[int]
var D:seq[int]
var E:seq[int]
var F:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  D = newSeqWith(M, 0)
  E = newSeqWith(M, 0)
  F = newSeqWith(M, 0)
  for i in 0..<M:
    D[i] = nextInt()
    E[i] = nextInt()
    F[i] = nextInt()
#}}}

#var adj = Array([3500, 3500], tuple[up, down, left, right:bool])
#var vis = Array([3500, 3500], bool)

var vis = Array(3500, 3500, false)

proc main() =
  var
    xs = @[-1000000010, 0, 1000000010]
    ys = @[-1000000010, 0, 1000000010]
  for i in 0..<N:
    xs.add(A[i])
    xs.add(B[i])
    ys.add(C[i])
  for i in 0..<M:
    xs.add(D[i])
    ys.add(E[i])
    ys.add(F[i])
  xs = xs.toSet().toSeq()
  xs.sort()
  ys = ys.toSet().toSeq()
  ys.sort()
  if xs.len < 2 or ys.len < 2:
    print "INF"
    return
  if xs.len >= 3500:
    while true:
      discard
  if ys.len >= 3500:
    while true:
      discard
#  dump(xs)
#  dump(ys)
  var adj = Seq(xs.len - 1, ys.len - 1, (up:true, down:true, left:true, right:true))
#  var vis = newSeqWith(xs.len - 1, newSeqWith(ys.len - 1, false))
#  for i in 0..<adj.len:
#    for j in 0..<adj[i].len:
#      adj[i][j].up = true
#      adj[i][j].down = true
#      adj[i][j].left = true
#      adj[i][j].right = true
  for i in 0..<N:
    let
      a = xs.lower_bound(A[i])
      b = xs.lower_bound(B[i])
      c = ys.lower_bound(C[i])
#    dump((i,A[i], B[i], C[i], a,b,c))
    for x in a..<b:
      if c < adj[x].len:
        adj[x][c].left = false
      if c - 1 >= 0:
        adj[x][c - 1].right = false
  for i in 0..<M:
    let
      d = xs.lower_bound(D[i])
      e = ys.lower_bound(E[i])
      f = ys.lower_bound(F[i])
    for y in e..<f:
      if d < adj.len:
        adj[d][y].up = false
      if d - 1 >= 0:
        adj[d - 1][y].down = false
  var
    x0 = xs.lower_bound(0)
    y0 = ys.lower_bound(0)
    ans = 0
    is_inf = false
  if x0 == xs.len - 1 or y0 == ys.len - 1:
    print "INF"
    return
  proc dfs(x,y:int) =
    var q = initDeque[(int,int)]()
    q.addFirst((x, y))
    while q.len > 0:
      if is_inf: return
      let (x, y) = q.popFirst()
      if x < 0 or x >= xs.len - 1 or y < 0 or y >= ys.len - 1:
        is_inf = true
        return
      if vis[x][y]: continue
      vis[x][y] = true
      ans += (xs[x + 1] - xs[x]) * (ys[y + 1] - ys[y])
      if adj[x][y].up: q.addLast((x - 1, y))
      if adj[x][y].down: q.addLast((x + 1, y))
      if adj[x][y].left: q.addLast((x, y - 1))
      if adj[x][y].right: q.addLast((x, y + 1))

  dfs(x0, y0)
  dfs(x0-1, y0)
  dfs(x0, y0-1)
  dfs(x0-1, y0-1)

  if is_inf:
    print "INF"
  else:
    print ans
  return

main()
