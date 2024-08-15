when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int], R:seq[int], B:seq[int], C:seq[int]):
  var
    As = Seq[5000 + 1: 0] # As[r] = ランクr以上に泊まりたい人の人数
    v = Seq[tuple[R, B, C: int]]
  block:
    for i in N:
      As[A[i]].inc
    for i in 1 ..< As.len << 1:
      As[i - 1] += As[i]
  for i in M:
    v.add (R[i], B[i], C[i])
  v.sort(SortOrder.Descending)
  var dp = Seq[N + 1: int.inf] # dp[i]: i部屋を確保するのにかかるコスト
  dp[0] = 0
  for i, (R, B, C) in v:
    var dp2 = dp # 部屋iを確保しない
    for j in 0 .. N:
      if dp[j].isInf: continue
      dp2[min(j + B, N)].min= dp[j] + C
    dp = dp2.move
    if i == M - 1 or v[i + 1].R < R:
      let u = if i == M - 1: 0 else: v[i + 1].R + 1
      # rank u以上を望む人がAs[u]人いる => As[u]人以上確保できていない場合は無効
      for j in 0 ..< As[u]:
        dp[j] = int.inf
  let ans = dp.min
  if ans.isInf:
    echo -1
  else:
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var R = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    R[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A, R, B, C)
else:
  discard

