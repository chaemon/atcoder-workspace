const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/other/bitutils

proc gaussian_elimination_bit[T:SomeInteger](a:seq[T], m = -1):tuple[a:seq[int], index:seq[int]] =
  var m = if m == -1: sizeof(T) * 4 else: m
  var
    n = a.len
    a = a
    ids = newSeq[int]()
    j = 0
  for i in 0 ..< n:
    while j < m:
      var pivot = -1
      for ii in i..<n:
        if a[ii][j] == 1:
          pivot = ii
          break
      if pivot != -1:
        swap(a[i], a[pivot])
        break
      j.inc
    if j == m: break
    #let d = M.p.div(M.p.unit(), A[i][j])
    #for jj in j..<m: A[i][jj] *= d
    for ii in 0..<n:
      if ii == i: continue
      #let d = A[ii][j]
      #for jj in j..<m: A[ii][jj] -= A[i][jj] * d
      if a[ii][j] == 1:
        a[ii] = a[ii] xor a[i]
    ids.add(j)
    j.inc
  a.setLen(ids.len)
  return (a, ids)

proc linearIndependent[T](a:seq[T], ids:seq[int], b:int):bool =
  var b = b
  for i in 0 ..< ids.len:
    if b[ids[i]] == 1:
      b = b xor a[i]
  return b != 0

#echo gaussian_elimination_bit(@[3, 1, 16, 29, 101])

proc calc(N, K:int):seq[int] =
  var v:seq[int]
  for b in 2^N:
    if b.popCount() == K:
      v.add b
  var
    a, ans:seq[int]
    found = false
  proc f() =
    if found: return
    if a.len == N:
      found = true
      ans = a
      return
    var (x, ids) = gaussian_elimination_bit(a)
    for v in v:
      if linearIndependent(x, ids, v):
        a.add v
        f()
        discard a.pop
  f()
  return ans

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, K:int):
  if K mod 2 == 0 or (K >= 2 and N == K):
    echo NO
    return
  proc build(n:int):seq[int] =
    if n == 1: return @[0, 1]
    result = build(n - 1)
    var v = result.reversed
    for v in v.mitems:
      v = v xor [n - 1]
    result = result & v
  var
    a = build(N)
    #d = newSeq[int](N)
    d = calc(N, K)
  #for i in N:
  #  for j in i ..< i + K:
  #    var j = j mod N
  #    d[i][j] = 1
  for a in a.mitems:
    b := 0
    for i in N:
      if a[i] == 1:
        b.xor=d[i]
    a = b.move
  echo YES
  echo a.join(" ")
  for i in 2^N:
    let j = (i + 1) mod 2^N
    doAssert a[i] in 0 ..< 2^N
    doAssert popCount(a[i] xor a[j]) == K
  Check(strm):
    r := strm.nextString()
    if r == "No": break
    P := Seq[2^N: strm.nextInt()]
    s := initSet[int]()
    for i in 2^N:
      doAssert P[i] notin s
      s.incl P[i]
      let j = (i + 1) mod 2^N
      doAssert P[i] in 0 ..< 2^N
      doAssert popCount(P[i] xor P[j]) == K
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  for N in 1..18:
    for K in 1..N:
      debug "test for ", N, K
      test(N, K)
