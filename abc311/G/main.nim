when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/dp/cumulative_sum_2d

template useIntConverter*() =
  converter toint8*(n:int):int8 = int8(n)
  converter toint16*(n:int):int16 = int16(n)
  converter toint32*(n:int):int32 = int32(n)
  converter toint64*(n:int):int64 = int64(n)
  converter touint8*(n:uint):uint8 = uint8(n)
  converter touint16*(n:uint):uint16 = uint16(n)
  converter touint32*(n:uint):uint32 = uint32(n)
  converter touint64*(n:uint):uint64 = uint64(n)

useIntConverter()

solveProc solve(N:int, M:int, A:seq[seq[int]]):
  type Int = int64
  var cs = initCumulativeSum2D[Int](N, M)
  for i in N:
    for j in M:
      cs.add(i, j, Int(A[i][j]))
  cs.build()
  var ans = -Int.inf
  for m in 1 .. 300: # Aの最小値: m以上のものだけ選ぶ
    var
      h = Seq[M: 0]
    for i in N:
      for j in M:
        h[j] = if A[i][j] >= m: h[j] + 1 else: 0
      var
        next, prev = Seq[M: int]
      for j in M:
        next[j] = j + 1
        prev[j] = j - 1
      var v:seq[tuple[h, j:int]]
      for j in M: v.add (h[j], j)
      # h[j]の大きい順にソート
      v.sort(SortOrder.Descending)
      for (h, j) in v:
        let
          L = prev[j] + 1
          R = next[j] - 1
        # i = i - h .. i, j = L .. Rの和を取る
        ans.max= cs[i - h + 1 .. i, L .. R] * m
        if prev[j] >= 0:
          next[prev[j]] = next[j]
        if next[j] < M:
          prev[next[j]] = prev[j]
        discard
  echo ans
  Naive:
    var ans = -int.inf
    for i0 in N:
      for i1 in i0 + 1 .. N:
        for j0 in M:
          for j1 in j0 + 1 .. M:
            var
              m = int.inf
              s = 0
            for x in i0 ..< i1:
              for y in j0 ..< j1:
                m.min= A[x][y]
                s += A[x][y]
            ans.max=m * s
    echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, A)
else:
  import random
  for _ in 100:
    var
      N = 20
      M = 50
      A = Seq[N, M: int]
      AMAX = 300
    for i in N:
      for j in M:
        A[i][j] = random.rand(1 .. AMAX)
    debug N, M, A
    test(N, M, A)
  discard

