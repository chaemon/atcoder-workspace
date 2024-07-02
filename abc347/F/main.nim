when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

#import lib/structure/segtree_2d_dense
import lib/dp/cumulative_sum_2d

#proc op(a, b:int):int = max(a, b)
#proc e():int = -int.inf

solveProc solve(N:int, M:int, A:seq[seq[int]]):
  var
    A = A
    ans = -int.inf
  proc rotate() =
    var B = A
    for x in N:
      for y in N:
        B[x][y] = A[N - 1 - y][x]
    swap A, B
  proc calc(k:int) =
    var cs = initCumulativeSum2D[int](N, N)
    for i in N:
      for j in N:
        cs.add(i, j, A[i][j])
    cs.build()
    let L = N - M + 1
    var v = Seq[L, L: 0]
    for i in 0 .. N - M:
      for j in 0 .. N - M:
        v[i][j] = cs[i ..< i + M, j ..< j + M]
    var
      row_max = Seq[L: int]
      row_range_max = Seq[L, L + 1: int]
    for i in L:
      row_max[i] = v[i].max

    for i in L:
      var a = 0
      for j in i + 1 .. L:
        a.max=row_max[j - 1]
        # i ..< j
        row_range_max[i][j] = a
    #var st = initSegmenttree2D[int](N - M + 1, N - M + 1, op, e)
    #for i in N - M + 1:
    #  for j in N - M + 1:
    #    st.set(i, j, v[i][j])
    #st.build()
    #proc rectMax(x, y:Slice[int]):int =
    #  if x.len < M or y.len < M: result = -int.inf
    #  else: result = st[x.a .. x.b - M + 1, y.a .. y.b - M + 1]
    var
      left, right = Seq[L + 1, L + 1: 0]
    block:
      var dp = v
      for i in v.len:
        for j in v.len:
          if i - 1 >= 0:
            dp[i][j].max=dp[i - 1][j]
          if j - 1 >= 0:
            dp[i][j].max=dp[i][j - 1]
          # 0 ..< i, 0 ..< j
          left[i + 1][j + 1] = dp[i][j]
    block:
      var dp = v
      for i in v.len:
        for j in countdown(v.len - 1, 0):
          if i - 1 >= 0:
            dp[i][j].max=dp[i - 1][j]
          if j + 1 < L:
            dp[i][j].max=dp[i][j + 1]
          right[i + 1][j] = dp[i][j]
    # T型
    for i in M .. N - M:
      for j in M .. N - M:
        #let
        #  a = rectMax(i ..< N, 0 ..< N)
        #  b = rectMax(0 ..< i, 0 ..< j)
        #  c = rectMax(0 ..< i, j ..< N)
        #if a == -int.inf or b == -int.inf or c == -int.inf: continue
        ans.max= left[i - M + 1][j - M + 1] + right[i - M + 1][j] + row_range_max[i][N - M + 1]
    # =型
    if k in [0, 1]:
      for i in M ..< N: # 0 ..< i
        for j in i + M ..< N: # i ..< j
          if N - j < M: continue # j ..< N
          ans.max=row_range_max[0][i - M + 1] + row_range_max[i][j - M + 1] + row_range_max[j][N - M + 1]
  for k in 4:
    calc(k)
    rotate()
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, M, A)
else:
  discard

