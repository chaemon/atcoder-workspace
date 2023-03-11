include atcoder/extra/header/chaemon_header

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

proc solve(N:int, T:int, A:seq[int]) =
  if N == 1:
    if A[0] <= T: echo A[0]
    else: echo 0
    return
  let
    N1 = N div 2
  proc getSeq(p, q:int):seq[int] =
    result = newSeq[int]()
    let d = q - p
    for b in 0..<(1 shl d):
      var s = 0
      for i in 0..<d:
        if b[i] == 1:
          s += A[p + i]
      result.add(s)
    result.sort()
  let
    a = getSeq(0, N1)
    b = getSeq(N1, N)
  var ans = 0
  var j = b.len - 1
  for i in 0..<a.len:
    while j >= 0 and a[i] + b[j] > T: j.dec
    if j >= 0: ans .max= a[i] + b[j]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var T = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, T, A)
#}}}
