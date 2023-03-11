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

proc solve(N:int, X:seq[int], Y:seq[int], Z:seq[int]) =
  proc dist(i, j:int):int = abs(X[i] - X[j]) + abs(Y[i] - Y[j]) + max(0, Z[i] - Z[j])
  var dp = Seq(1 shl N, N, int.inf)
  dp[1 shl 0][0] = 0
  for b in 0..<2^N:
    for u in 0..<N:
      if b[u] == 0: continue
      if dp[b][u] == int.inf: continue
      for v in 0..<N:
        if b[v] == 1: continue
        dp[b or (1 shl v)][v].min= dp[b][u] + dist(u, v)
  var ans = int.inf
  for u in 1..<N:
    ans.min=dp[(1 shl N) - 1][u] + dist(u, 0)
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  var Z = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
    Z[i] = nextInt()
  solve(N, X, Y, Z)
#}}}
