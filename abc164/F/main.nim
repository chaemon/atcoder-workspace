#{{{ header
{.hints:off warnings:off optimization:speed.}
import algorithm, sequtils, tables, macros, math, sets, strutils, future
when defined(MYDEBUG):
  import header

import streams
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
#proc getchar(): char {.header: "<stdio.h>", varargs.}
proc nextInt(): int = scanf("%lld",addr result)
proc nextUInt(): uint = scanf("%llu",addr result)
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

proc newSeqWithImpl[T](lens: seq[int]; init: T; currentDimension, lensLen: static[int]): auto =
  when currentDimension == lensLen:
    newSeqWith(lens[currentDimension - 1], init)
  else:
    newSeqWith(lens[currentDimension - 1], newSeqWithImpl(lens, init, currentDimension + 1, lensLen))

template Seq*[T](lens: varargs[int]; init: T): untyped =
  newSeqWithImpl(@lens, init, 1, lens.len)
#}}}

var N:int
var S:seq[uint]
var T:seq[uint]
var U:seq[uint]
var V:seq[uint]

#{{{ input part
proc main()
block:
  N = nextInt()
  S = newSeqWith(N, nextUInt())
  T = newSeqWith(N, nextUInt())
  U = newSeqWith(N, nextUInt())
  V = newSeqWith(N, nextUInt())
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

proc check(ans:seq[seq[uint]]) =
  for i in 0..<N:
    if S[i] == 0:
      var s = not 0.uint
      for j in 0..<N: s = s and ans[i][j]
      doAssert(s == U[i].uint)
    else:
      var s = 0.uint
      for j in 0..<N: s = s or ans[i][j]
      doAssert(s == U[i].uint)
  for j in 0..<N:
    if T[j] == 0:
      var s = not 0.uint
      for i in 0..<N:
        s = s and ans[i][j]
      doAssert(s == V[j].uint)
    else:
      var s = 0.uint
      for i in 0..<N: s = s or ans[i][j]
      doAssert(s == V[j])

proc calc(U, V:seq[int]):(bool, seq[seq[int]]) =
#  var ans = Seq(N, N, 0.uint)
  var ans = newSeqWith(N, newSeqWith(N, 0))
  var
    rid = newSeq[int](N)
    cid = newSeq[int](N)
  for i in 0..<N:
    if S[i] == 0: # and
      if U[i] == 1:
        rid[i] = 1
      else:
        rid[i] = 2
    else: # or
      if U[i] == 0:
        rid[i] = 0
      else:
        rid[i] = 2
  for j in 0..<N:
    if T[j] == 0: # and
      if V[j] == 1:
        cid[j] = 1
      else:
        cid[j] = 2
    else: # or
      if V[j] == 0:
        cid[j] = 0
      else:
        cid[j] = 2
  var
    zero_row = rid.count(0)
    one_row = rid.count(1)
    zero_col = cid.count(0)
    one_col = cid.count(1)
#  dump(S)
#  dump(T)
#  dump(U)
#  dump(V)
#  dump(zero_row)
#  dump(one_row)
#  dump(zero_col)
#  dump(one_col)
  if zero_row == N: # all 0
    for j in 0..<N:
      if V[j] == 1:
        return (false, ans)
    for i in 0..<N:
      for j in 0..<N:
        ans[i][j] = 0
  elif zero_col == N: # all 0
    for i in 0..<N:
      if U[i] == 1:
        return (false, ans)
    for i in 0..<N:
      for j in 0..<N:
        ans[i][j] = 0
  elif one_row == N: # all 1
    for j in 0..<N:
      if V[j] == 0:
        return (false, ans)
    for i in 0..<N:
      for j in 0..<N:
        ans[i][j] = 1
  elif one_col == N: # all 1
    for i in 0..<N:
      if U[i] == 0:
        return (false, ans)
    for i in 0..<N:
      for j in 0..<N:
        ans[i][j] = 1
  elif zero_row > 0 and one_col > 0:
    return (false, ans)
  elif zero_col > 0 and one_row > 0:
    return (false, ans)
  elif zero_row > 0 and one_row > 0:
    for i in 0..<N:
      for j in 0..<N:
        if rid[i] == 0:
          ans[i][j] = 0
        elif rid[i] == 1:
          ans[i][j] = 1
        elif j <= 1:
          ans[i][j] = (i + j) mod 2
  elif zero_col > 0 and one_col > 0:
    for i in 0..<N:
      for j in 0..<N:
        if cid[j] == 0:
          ans[i][j] = 0
        elif cid[j] == 1:
          ans[i][j] = 1
        elif i <= 1:
          ans[i][j] = (i + j) mod 2
  elif zero_row > 0 and zero_col > 0:
    for i in 0..<N:
      for j in 0..<N:
        if rid[i] == 0 or cid[j] == 0:
          ans[i][j] = 0
        else:
          ans[i][j] = 1
  elif one_row > 0 and one_col > 0:
    for i in 0..<N:
      for j in 0..<N:
        if rid[i] == 1 or cid[j] == 1:
          ans[i][j] = 1
        else:
          ans[i][j] = 0
  elif zero_row > 0:
    let rest_row = toSeq(0..<N).filterIt(rid[it] != 0)
    if rest_row.len == 1:
      let r0 = rest_row[0]
      var found = false
      if U[r0] == 0:
        if V.filterIt(it==1).len == N: return (false, ans)
        for j in 0..<N:
          ans[r0][j] = V[j]
      else:
        for j in 0..<N:
          ans[r0][j] = 1
    else:
      for c, i in rest_row:
        for j in 0..<N:
          ans[i][j] = (c + j) mod 2
    for i in 0..<N:
      for j in 0..<N:
        if rid[i] == 0:
          ans[i][j] = 0
  elif zero_col > 0:
    let rest_col = toSeq(0..<N).filterIt(cid[it] != 0)
    if rest_col.len == 1:
      let c0 = rest_col[0]
      var found = false
      if V[c0] == 0:
        if U.filterIt(it==1).len == N: return (false, ans)
        for i in 0..<N:
          ans[i][c0] = U[i]
      else:
        for i in 0..<N:
          ans[i][c0] = 1
    else:
      for c, j in rest_col:
        for i in 0..<N:
          ans[i][j] = (c + i) mod 2
    for i in 0..<N:
      for j in 0..<N:
        if cid[j] == 0:
          ans[i][j] = 0
  elif one_row > 0:
    let rest_row = toSeq(0..<N).filterIt(rid[it] != 1)
    if rest_row.len == 1:
      let r0 = rest_row[0]
      var found = false
      if U[r0] == 1:
        if V.filterIt(it==0).len == N: return (false, ans)
        for j in 0..<N:
          ans[r0][j] = V[j]
      else:
        for j in 0..<N:
          ans[r0][j] = 0
    else:
      for c, i in rest_row:
        for j in 0..<N:
          ans[i][j] = (c + j) mod 2
    for i in 0..<N:
      for j in 0..<N:
        if rid[i] == 1:
          ans[i][j] = 1
  elif one_col > 0:
    let rest_col = toSeq(0..<N).filterIt(cid[it] != 1)
    if rest_col.len == 1:
      let c0 = rest_col[0]
      var found = false
      if V[c0] == 1:
        if U.filterIt(it==0).len == N: return (false, ans)
        for i in 0..<N:
          ans[i][c0] = U[i]
      else:
        for i in 0..<N:
          ans[i][c0] = 0
    else:
      for c, j in rest_col:
        for i in 0..<N:
          ans[i][j] = (c + i) mod 2
    for i in 0..<N:
      for j in 0..<N:
        if cid[j] == 1:
          ans[i][j] = 1
  else:
    doAssert(zero_row == 0 and zero_col == 0 and one_row == 0 and one_col == 0)
    for i in 0..<N:
      for j in 0..<N:
        ans[i][j] = (i + j) mod 2
#  dump(U)
#  dump(V)
#  dump(ans)
  return (true, ans)


proc main() =
  if N == 1:
    if U[0] == V[0]:
      echo U[0]
    else:
      echo -1
    return
  var ans = newSeqWith(N, newSeqWith(N, 0.uint))
#  var ans = Seq(N, N, 0.uint)
  for c in 0..<64:
#  block:
#    let c = 3
    let
      U = U.mapIt(it[c])
      V = V.mapIt(it[c])
    let (r,a) = calc(U, V)
    if not r:
      echo -1;return
    for i in 0..<N:
      for j in 0..<N:
        ans[i][j][c] = a[i][j]
  for i in 0..<N:
    for j in 0..<N:
      stdout.write ans[i][j].uint
#      stdout.write ans[i][j]
      if j < N - 1:
        stdout.write(" ")
    echo ""
  ans.check()
  return

main()
