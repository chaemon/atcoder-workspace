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
type someInteger = int|int8|int16|int32|int64|BiggestInt
type someUnsignedInt = uint|uint8|uint16|uint32|uint64
type someFloat = float|float32|float64|BiggestFloat
template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template inf(T): untyped = 
  when T is someFloat: T(Inf)
  elif T is someInteger|someUnsignedInt: ((T(1) shl T(sizeof(T)*8-2)) - (T(1) shl T(sizeof(T)*4-1)))
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

import strutils, sequtils, algorithm

#{{{ bitutils
import bitops

proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if b.testBit(n): 1 else: 0)
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (B(1) shl (s.b - s.a + 1))

proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.clearBit(n)
  elif t == 1: b.setBit(n)
  else: doAssert(false)
proc writeBits[B:SomeInteger](b:B) =
  var n = sizeof(B) * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
proc setBits[B:SomeInteger](n:int):B =
  if n == 64:
    return not uint64(0)
  else:
    return (B(1) shl B(n)) - B(1)
iterator subsets[B:SomeInteger](b:B):B =
  var v = newSeq[int]()
  for i in 0..<(8 * sizeof(B)):
    if b[i] == 1: v.add(i)
  var s = B(0)
  yield s
  while true:
    var found = false
    for i in v:
      if not s.testBit(i):
        found = true
        s.setBit(i)
        yield s
        break
      else:
        s[i] = 0
    if not found: break
#}}}

#{{{ bitset
import strutils, sequtils, algorithm

const BitWidth = 64

# {{{ BitSet
type BitSet[N:static[int]] = ref object
  data: array[(N + BitWidth - 1) div BitWidth, uint64]

proc initBitSet[N:static[int]](): BitSet[N] =
  const size = (N + BitWidth - 1) div BitWidth
  var data: array[size, uint64]
  return BitSet[N](data: data)
proc initBitSet1[N:static[int]](): BitSet[N] =
  result = initBitSet(N)
  let
    q = (N + BitWidth - 1) div BitWidth
    r = N div BitWidth
  for i in 0..<q:result.data[i] = (not 0'u64)
  if r > 0:result.data[q] = ((1'u64 shl uint64(r)) - 1)
proc init[N:static[int]](self: BitSet[N]):BitSet[N] = initBitSet[N]()
proc init1[N:static[int]](self: BitSet[N]):BitSet[N] = initBitSet1[N]()
proc getSize[N:static[int]](self: BitSet[N]):int = N
#}}}
# {{{ DynamicBitSet
type DynamicBitSet = ref object
  N:int
  data: seq[uint64]

proc initDynamicBitSet(N:int): DynamicBitSet =
  let size = (N + BitWidth - 1) div BitWidth
  return DynamicBitSet(N:N, data:newSeqWith(size, 0'u64))
proc initDynamicBitSet1(N:int): DynamicBitSet =
  result = initDynamicBitSet(N)
  let
    q = (N + BitWidth - 1) div BitWidth
    r = N div BitWidth
  for i in 0..<q:result.data[i] = (not 0'u64)
  if r > 0:result.data[q] = ((1'u64 shl uint64(r)) - 1)
proc init(self: DynamicBitSet):DynamicBitSet = initDynamicBitSet(self.N)
proc init1(self: DynamicBitSet):DynamicBitSet = initDynamicBitSet1(self.N)
proc getSize(self: DynamicBitSet):int = self.N
#}}}


# operations {{{
type BitSetC = concept x
#  x.data
  x.getSize()
  x.init()
#  x.init1()

proc toBin(b:uint64, n: int): string =
  result = ""
  for i in countdown(n-1, 0):
    if (b and (1'u64 shl uint64(i))) != 0'u64: result &= "1"
    else: result &= "0"

proc `$`(a: BitSetC):string =
  let N = a.getSize()
  var
    q = N div BitWidth
    r = N mod BitWidth
  var v = newSeq[string]()
  for i in 0..<q: v.add(a.data[i].toBin(BitWidth))
  if r > 0: v.add(a.data[q].toBin(r))
  v.reverse()
  return v.join("")

proc `not`(a: BitSetC): auto =
  result = a.init1()
  for i in 0..<a.data.len: result.data[i] = (not a.data[i]) and result.data[i]
proc `or`(a, b: BitSetC): auto =
  result = a.init()
  for i in 0..<a.data.len: result.data[i] = a.data[i] or b.data[i]
proc `and`(a, b: BitSetC): auto =
  result = a.init()
  for i in 0..<a.data.len: result.data[i] = a.data[i] and b.data[i]
proc `xor`(a, b: BitSetC): auto =
  result = a.init()
  for i in 0..<a.data.len: result.data[i] = a.data[i] xor b.data[i]

proc any(a: BitSetC): bool = 
  let N = a.getSize()
  var
    q = N div BitWidth
    r = N mod BitWidth
  for i in 0..<q:
    if a.data[i] != 0.uint64: return true
  if r > 0 and (a.data[^1] and setBits[uint64](r)) != 0.uint64: return true
  return false

proc all(a: BitSetC): bool =
  let N = a.getSize()
  var
    q = N div BitWidth
    r = N mod BitWidth
  for i in 0..<q:
    if (not a.data[i]) != 0.uint64: return false
  if r > 0 and a.data[^1] != setBits[uint64](r): return false
  return true

proc `[]`(b:BitSetC,n:int):int =
  let N = b.getSize()
  assert 0 <= n and n < N
  let
    q = n div BitWidth
    r = n mod BitWidth
  return b.data[q][r]
proc `[]=`(b:var BitSetC,n:int,t:int) =
  let N = b.getSize()
  assert 0 <= n and n < N
  assert t == 0 or t == 1
  let
    q = n div BitWidth
    r = n mod BitWidth
  b.data[q][r] = t

proc `shl`(a: BitSetC, n:int): auto =
  result = a.init()
  var r = int(n mod BitWidth)
  if r < 0: r += BitWidth
  let q = (n - r) div BitWidth
  let maskl = setBits[uint64](BitWidth - r)
  for i in 0..<a.data.len:
    let d = (a.data[i] and maskl) shl uint64(r)
    let i2 = i + q
    if 0 <= i2 and i2 < a.data.len: result.data[i2] = result.data[i2] or d
  if r != 0:
    let maskr = setBits[uint64](r) shl uint64(BitWidth - r)
    for i in 0..<a.data.len:
      let d = (a.data[i] and maskr) shr uint64(BitWidth - r)
      let i2 = i + q + 1
      if 0 <= i2 and i2 < a.data.len: result.data[i2] = result.data[i2] or d
  block:
    let r = a.getSize() mod BitWidth
    if r != 0:
      let mask = not (setBits[uint64](BitWidth - r) shl uint64(r))
      result.data[^1] = result.data[^1] and mask
proc `shr`(a: BitSetC, n:int): auto = a shl (-n)
#}}}
#}}}

proc solve(N:int, A:seq[int]) =
  var bs = initBitSet[2000001]()
#  var bs = initStaticBitSet(20000001)
  bs[0] = 1
  var S = 0
  for i in 0..<N:
    bs = bs or (bs shl A[i])
    S += A[i]
  for s in countdown(S div 2, 0):
    if bs[s] == 1:
      echo S - s
      return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
  solve(N, A);
  return

main()
#}}}
