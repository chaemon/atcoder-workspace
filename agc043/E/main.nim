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

proc ndSeqImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], ndSeqImpl(lens, init, currentDimension + 1, lensLen))

template ndSeq*[T](lens: varargs[int]; init: T): untyped =
  ndSeqImpl(@lens, init, 1, lens.len)
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
iterator subsets[B:SomeInteger](b:B):B =
  var v = newSeq[int]()
  for i in 0..<(8 * sizeof(B)):
    if b[i] == 1: v.add(i)
  var s = B(0)
  while true:
    var found = false
    for i in v:
      if s[i] == 0:
        found = true
        s[i] = 1
        yield s
        break
      else:
        s[i] = 0
    if not found: break
#}}}

const YES = "Possible"
const NO = "Impossible"

N := nextInt()
A := nextString()

proc dist(a, b:(int,int)):int =
  return abs(a[0] - b[0]) + abs(a[1] - b[1])

proc check(ans: seq[(int,int)]) =
  doAssert(ans[0] == ans[^1])
  for i in 0..<ans.len - 1:
    doAssert(dist(ans[i], ans[i+1]) == 1)

proc add_cycle(ans:var seq[(int,int)], b:int) =
  ans.add((0, 0))
  prev := 0
  for i in 0..<N:
    if b[i] == 1:
      if prev == 0:
        ans.add((i, 1))
      ans.add((i + 1, 1))
    else:
      if prev == 1:
        ans.add((i, 0))
      ans.add((i + 1, 0))
    prev = b[i]
  if prev == 1:
    ans.add((N, 0))
  for i in countdown(N - 1, 1):
    ans.add((i, 0))

proc main() =
  for b in subsets(10):
    echo b
  while true:
    discard
  ans := newSeq[(int,int)]()
  inspect := ndSeq(1 shl N, false)
  for b2 in countdown((1 shl N) - 1, 0):
    if inspect[b2]: continue
    v := newSeq[int]()
    for i in 0..<N:
      if b2[i] == 1: v.add(i)
    if A[b2] == '0': continue
    doAssert(A[b2] == '1')
    for b0 in 0..<(1 shl v.len):
      bb := 0
      for i in 0..<v.len:
        if b0[i] == 1:
          bb[v[i]] = 1
        else:
          bb[v[i]] = 0
      if A[bb] == '0':
        print NO
        return
      inspect[bb] = true
  for b in 0..<A.len:
    if A[b] == '0':
      ans.add_cycle(b)
  ans.add((0, 0))
  check(ans)
  print YES
  print ans.len - 1
  for p in ans:
    print p[0], p[1]
  return

main()
