#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils
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

#{{{ bitutils
proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (b shr n) mod 2
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (1 shl (s.b - s.a + 1))
proc test[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc set[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc unset[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))
proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.unset(n)
  elif t == 1: b.set(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int) =
  var n = n * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
proc builtin_ctz(n:int):int =
  for i in 0..<(8 * sizeof(n)):
    if n[i] == 1: return i
  assert(false)
proc builtin_popcount(n:int):int =
  result = 0
  for i in 0..<(8 * sizeof(n)):
    if n[i] == 1: result += 1
#}}}

var N:int
var K:int
var w:seq[seq[int]]

#{{{ input part
proc main()
block:
  N = nextInt()
  K = nextInt()
  w = newSeqWith(N, newSeqWith(N, nextInt()))
#}}}

score := newSeq[int](1 shl N)

proc main() =
  let B = (1 shl N)
  score[0] = 0
  for b in 1..<B:
    var c = -1
    for i in 0..<N:
      if b[i] == 1: c = i
    var b2 = b
    b2[c] = 0
    s := score[b2]
    for u in 0..<N:
      if u == c: continue
      if b2[u] == 1:
        s -= w[u][c]
      else:
        s += w[u][c]
    score[b] = s
#  echo score
  dp := newSeq[int](1 shl N)
  dp[0] = 0
  for b in 0..<B - 1:
    v := newSeq[int]()
    for i in 0..<N:
      if b[i] == 0: v.add(i)
    var
      b2 = 0
    while true:
      # next
      var 
        valid = true
        i = 0
      while true:
#        echo v, i
        if b2[v[i]] == 1:
          b2[v[i]] = 0
          i += 1
          if i == v.len:
            valid = false
            break
        else:
          b2[v[i]] = 1
          break
      if not valid: break
      dp[b or b2] .max= K * 2 - score[b2] + dp[b]
  echo dp[B - 1] div 2
  return

main()
