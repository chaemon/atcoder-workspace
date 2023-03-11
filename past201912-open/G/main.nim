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

#{{{ bitutils
proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if (b and (B(1) shl B(n))) == 0: 0 else: 1)
proc test[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
proc set[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
proc unset[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))
proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.unset(n)
  elif t == 1: b.set(n)
  else: assert(false)
proc writeBits[B:SomeInteger](b:B,n:int = sizeof(B)) =
  var n = n * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
#}}}

#{{{ main function
proc main() =
  let N = nextInt()
  A := newSeqWith(N, newSeqWith(N, 0))
  for i in 0..<N:
    for j in i+1..<N:
      let aij = nextInt()
      A[i][j] = aij
      A[j][i] = aij
  vis := newSeqWith(1 shl N, false)
  dp := newSeqWith(1 shl N, -int.inf)
  dp[0] = 0
  for ct in 0..<3:
    dp2 := dp
    for b in 0..<(1 shl N):
      if dp[b] == -int.inf: continue
      v := newSeq[int]()
      for i in 0..<N:
        if b[i] == 0: v.add(i)
      for t in 1..<(1 shl v.len):
        var b2 = b
        var v2 = newSeq[int]()
        for j in 0..<v.len:
          if t[j] == 1:
            v2.add(v[j])
            b2[v[j]] = 1
        d := 0
        for i in 0..<v2.len:
          for j in i+1..<v2.len:
            d += A[v2[i]][v2[j]]
        dp2[b2].max=dp[b] + d
    swap(dp, dp2)
  echo dp[(1 shl N) - 1]
  return

main()
#}}}
