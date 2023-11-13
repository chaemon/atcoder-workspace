when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils
import std/heapqueue

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, p:seq[int], t:seq[int], s:seq[int], g:seq[int]):
  Pred p
  shadow t, s, g
  p = -1 & p
  t = 2 & t
  s = 0 & s
  g = 1 & g

  # p[u]はuの親、p[0] = -1となる
  var v:seq[int] # 薬のあるところ 米0も含める
  v.add 0
  for u in 1 ..< N:
    if t[u] == 2:
      v.add u
  var c = Seq[N: seq[int]] # 子のノード
  for u in 1 ..< N:
    c[p[u]].add u
  const INF = 10^9 + 1
  var dp = Seq[2^v.len: -INF] # dp[b]はビット列bの薬を取った時点での体力の最大値
  dp[0] = 1 # 親にいるとき強さ1
  for b in 2^v.len:
    if dp[b] == -INF: continue
    # dp[b]が決まっているとする
    var vis = Seq[N: 0] # 0: 通行可, 1: 通行済み, -1: 通行不可
    for i in v.len:
      if b[i] == 0:
        vis[v[i]] = -1 # まだ通っていない薬のノードはdfsで通ってはならない
    var q = initHeapQueue[tuple[s, u:int]]()
    proc dfs(u:int) =
      if vis[u] == -1: return
      if s[u] <= dp[b]: vis[u] = 1
      else:
        q.push((s[u], u))
        return
      for v in c[u]:
        dfs(v)
    dfs(0)
    for i in v.len:
      if b[i] == 1: continue
      # xにある薬を次にとる
      let x = v[i]
      if p[x] > 0 and vis[p[x]] != 1: continue
      var
        V = dp[b] # 今の強さ
        b2 = b xor [i]
        q = q
      if V < INF:
        V *= g[x]
        V.min= INF
      for v in c[x]:
        if t[v] == 1:
          q.push((s[v], v))
      while q.len > 0:
        let (_, v) = q.pop()
        if V < s[v]: break
        if V < INF:
          V += g[v]
          V.min= INF
      dp[b2].max=V
    discard
  if dp[^1] == -INF or dp[^1] < s.max:
    echo NO
  else:
    echo YES
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = newSeqWith(N-2+1, 0)
  var t = newSeqWith(N-2+1, 0)
  var s = newSeqWith(N-2+1, 0)
  var g = newSeqWith(N-2+1, 0)
  for i in 0..<N-2+1:
    p[i] = nextInt()
    t[i] = nextInt()
    s[i] = nextInt()
    g[i] = nextInt()
  solve(N, p, t, s, g)
else:
  discard

