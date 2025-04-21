when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  let n = (N + 1) div 2
  if (n * (n - 1)) div 2 > M:
    # 最大のクリークが辺をもつことはできない
    echo NO;return
  Pred A, B
  var a = Seq[N, N: true] # 補グラフ
  for u in N:
    a[u][u] = false
  for i in M:
    a[A[i]][B[i]] = false
    a[B[i]][A[i]] = false
  var
    vis = Seq[N: -1]
    ok = true
  proc dfs(u, c:int) =
    if vis[u] != -1:
      if c != vis[u]: ok = false;return
      return
    vis[u] = c
    for v in 0 ..< N:
      if not a[u][v]: continue
      dfs(v, c xor 1)
      if not ok: return
  for u in N:
    if vis[u] != -1: continue
    dfs(u, 0)
    if not ok: echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var M = nextInt()
    var A = newSeqWith(M, 0)
    var B = newSeqWith(M, 0)
    for i in 0..<M:
      A[i] = nextInt()
      B[i] = nextInt()
    solve(N, M, A, B)
else:
  discard

