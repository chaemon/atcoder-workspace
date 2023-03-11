const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitset

solveProc solve(N:int, A:seq[string]):
  var v = Seq[N: initBitSet[3000]()]
  for i in N:
    for j in N:
      if A[i][j] == '1': v[i][j] = 1
  var ans = 0
  for i in N:
    for j in i + 1..<N:
      if A[i][j] == '0': continue
      ans += (v[i] and v[j]).count
  doAssert ans mod 3 == 0
  ans.div= 3
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextString())
  solve(N, A)
else:
  discard

