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

proc solve(N:int) =
  var d = newSeq[int]()
  var N2 = N
  while N2 > 0:
    d.add N2 mod 10
    N2 = N2 div 10
  var ans = int.inf
  for b in 1..<(1 shl d.len):
    var
      s = 0
      n = 0
    for i in 0..<d.len:
      if b[i] == 1:
        s += d[i]
        n.inc
    if s mod 3 == 0:
      ans.min= d.len - n
  if ans == int.inf:
    echo -1
  else:
    echo ans
  return

# input part {{{
block:
  var N = nextInt()
  solve(N)
#}}}
