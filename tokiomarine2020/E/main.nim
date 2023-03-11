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

# dump {{{
import macros

macro dump*(n: varargs[untyped]): untyped =
  result = newNimNode(nnkStmtList, n)
  for i,x in n:
    result.add(newCall("write", newIdentNode("stderr"), toStrLit(x)))
    result.add(newCall("write", newIdentNode("stderr"), newStrLitNode(" = ")))
    result.add(newCall("write", newIdentNode("stderr"), x))
    if i < n.len - 1: result.add(newCall("write", newIdentNode("stderr"), newStrLitNode(", ")))
  result.add(newCall("write", newIdentNode("stderr"), newStrLitNode("\n")))
# }}}

var N:int
var K:int
var S:int
var T:int
var A:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  K = nextInt()
  S = nextInt()
  T = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

#{{{ bitutils
import bitops

proc bits[B:SomeInteger](v:varargs[int]): B =
  result = 0
  for x in v: result = (result or (B(1) shl B(x)))
proc `[]`[B:SomeInteger](b:B,n:int):int = (if b.testBit(n): 1 else: 0)
proc `[]`[B:SomeInteger](b:B,s:Slice[int]):int = (b shr s.a) mod (B(1) shl (s.b - s.a + 1))
#proc testBit[B:SomeInteger](b:B,n:int):bool = (if b[n] == 1:true else: false)
#proc setBit[B:SomeInteger](b:var B,n:int) = b = (b or (B(1) shl B(n)))
#proc clearBit[B:SomeInteger](b:var B,n:int) = b = (b and (not (B(1) shl B(n))))

proc `[]=`[B:SomeInteger](b:var B,n:int,t:int) =
  if t == 0: b.clearBit(n)
  elif t == 1: b.setBit(n)
  else: doAssert(false)
proc writeBits[B:SomeInteger](b:B) =
  var n = sizeof(B) * 8
  for i in countdown(n-1,0):stdout.write(b[i])
  echo ""
#proc setBits[B:SomeInteger](n:int):B = return (B(1) shl B(n)) - B(1)
#proc countTrailingZeroBits(n:int):int =
#  for i in 0..<(8 * sizeof(n)):
#    if n[i] == 1: return i
#  assert(false)
#proc popcount(n:int):int =
#  result = 0
#  for i in 0..<(8 * sizeof(n)):
#    if n[i] == 1: result += 1
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

#{{{ default-table
proc getDefault(T:typedesc): T =
  when T is string: ""
  elif T is seq: @[]
  else:
    (var temp:T;temp)

proc getDefault[T](x:T): T = getDefault(T)

import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, getDefault(B))
  tables.`[]`(self, key)
#}}}

# binomialTable(N:int) {{{
proc binomialTable(N:int):seq[seq[int]] =
  result = newSeqWith(N+1, newSeq[int]())
  for i in 0..N:
    result[i] = newSeqWith(i + 1, 0)
    for j in 0..i:
      if j == 0 or j == i: result[i][j] = 1
      else: result[i][j] = result[i - 1][j - 1] + result[i - 1][j]
# }}}

var dp = newSeq[int](N)
const B = 18

proc main() =
  var
    target = newSeq[int]()
    zero_list = newSeq[int]()
    one_list = newSeq[int]()
    comb = binomialTable(51)
    comb_sum = comb
  for n in 0..<comb.len:
    s := 0
    for r in 0..<comb[n].len:
      s += comb[n][r]
      comb_sum[n][r] = s
  for i in 0..<B:
    let
      s = S[i]
      t = T[i]
    if s == t:
      if s == 0:
        zero_list.add(i)
      else:
        one_list.add(i)
    elif s == 1 and t == 0:
      print 0
      return
    else:
      target.add(i)
  var A2 = newSeq[int]()
  for a in A:
    var valid = true
    for i in zero_list:
      if a[i] != 0:
        valid = false
    for i in one_list:
      if a[i] != 1:
        valid = false
    if valid: A2.add(a)
  swap(A, A2)
  N = A.len
  ans := 0
  for b in 0..<2^target.len:
    tb := initTable[int,int]()
    for i in 0..<N:
      s := 0
      for j,t in target:
        if b[j] == 1 and A[i][t] == 1:
          s[j] = 1
      tb[s].inc
    t := 0
    for k, v in tb:
      if v >= K:
        t += comb_sum[v][K] - 1
      else:
        t += comb_sum[v][v] - 1
    if b.popcount() mod 2 == 0:
      ans += t
    else:
      ans -= t
  print ans
  return

main()
