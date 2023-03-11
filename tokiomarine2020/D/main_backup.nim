#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, sugar
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

template SeqImpl(lens: seq[int]; init; d: int): auto =
  when d + 1 == lens.len:
    when init is typedesc: newSeq[init](lens[d])
    else: newSeqWith(lens[d], init)
  else: newSeqWith(lens[d], SeqImpl(lens, init, d + 1))

template Seq(lens: varargs[int]; init): auto = SeqImpl(@lens, init, 0)

template ArrayImpl(lens: varargs[int]; init: typedesc; d: int): typedesc =
  when d + 1 == lens.len: array[lens[d], init]
  else: array[lens[d], ArrayImpl(lens, init, d + 1)]

template ArrayFill(a, val): void =
  when a is array:
    for v in a.mitems: ArrayFill(v, val)
  else:
    a = val

template Array(lens: varargs[int]; init): auto =
  when init is typedesc:
    ArrayImpl(@lens, init, 0).default
  else:
    var a:ArrayImpl(@lens, typeof(init), 0)
    ArrayFill(a, init)
    a
#}}}

var N:int
var V:seq[int]
var W:seq[int]
var Q:int
var v:seq[int]
var L:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  V = newSeqWith(N, 0)
  W = newSeqWith(N, 0)
  for i in 0..<N:
    V[i] = nextInt()
    W[i] = nextInt()
  Q = nextInt()
  v = newSeqWith(Q, 0)
  L = newSeqWith(Q, 0)
  for i in 0..<Q:
    v[i] = nextInt() - 1
    L[i] = nextInt()
#}}}

proc merge(a, b:array[2^9, (int,int)], l:int, c: var array[2^9, (int,int)]):int =
  proc maximize(a:(int,int), v:var int):(int,int) =
    v.max=a[1]
    result = a
    result[1].max=v
  var
    i = 0
    j = 0
    val_max = 0
    k = 0
  while true:
    if i == l:
      if j == l:
        break
      else:
        c[k] = b[j].maximize(val_max)
        j.inc
    elif j == l:
      c[k] = (a[i].maximize(val_max))
      i.inc
    else:
      if a[i][0] < b[j][0]:
        c[k] = (a[i].maximize(val_max))
        i.inc
      elif a[i][0] > b[j][0]:
        c[k] = (b[j].maximize(val_max))
        j.inc
      else:
        val_max.max= max(a[i][1], b[j][1])
        c[k] = (a[i].maximize(val_max))
        i.inc;j.inc
    k.inc
  return k

#var dp = newSeq[seq[(int,int)]](N)
var dp = Array(2^18, 2^9, (int,int))
var lens = Array(2^18, int)

proc dfs(i, h, p:int) =
  if i >= N: return
  var
    a: array[2^9, (int,int)]
    l:int
  if h == 9 or h == 0:
#    a = @[(0, 0)]
    l = 1
  else:
    a = dp[p]
    l = lens[p]
  var b = a
  for j in 0..<l:
    b[j][0] += W[i]
    b[j][1] += V[i]
#  dp[i] = merge(a, b)
  lens[i] = merge(a, b, l, dp[i])
  dfs(i * 2 + 1, h + 1, i)
  dfs(i * 2 + 2, h + 1, i)

dfs(0, 0, -1)

proc calc(v, w: int, L:int):int =
  var
    ans = 0
    j = lens[w] - 1
  for i in 0..<lens[v]:
    while j >= 0 and dp[w][j][0] + dp[v][i][0] > L: j.dec
    if j < 0: break
    ans.max=dp[v][i][1] + dp[w][j][1]
  return ans

proc query(v, L:int) =
  var h = 0
  var v2 = v
  while v2 > 0:
    v2 = (v2 - 1) div 2
    h.inc
  var ans = 0
  if h < 9:
    for i in 0..<dp[v].len:
      if dp[v][i][0] <= L:
        ans.max=dp[v][i][1]
  else:
    var
      p = v
      hp = h
    while hp > 8:
      p = (p - 1) div 2
      hp.dec
    ans = calc(p, v, L)
  print ans
  discard

proc main() =
  for q in 0..<Q:
    query(v[q], L[q])
  return

main()
