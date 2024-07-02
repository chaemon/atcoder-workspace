when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/graph/graph_template
import lib/tree/heavy_light_decomposition

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, M:int, K:int, P:seq[int], S:seq[int], T:seq[int]):
  Pred P, S, T
  var
    G = initGraph[int](N)
    child = Seq[N: seq[int]]
    direction = Seq[N: 0] # 子供を2つ持つノードについて、0 -> 1なら1, 1 -> 0なら-1, どっちでもいいなら0
  for u in N - 1:
    # u + 1の親はP[u]
    G.addBiEdge(u + 1, P[u])
    child[P[u]].add u + 1
  var
    hld = initHeavyLightDecomposition(G, 0)
    ct_start, ct_end = Seq[N: 0]
    non_direct_start, non_direct_end = Seq[N: 0]
    direct_up_start = Seq[N: 0]
    direct_up_end = Seq[N: seq[int]]
    direct_down_start = Seq[N: seq[int]]
    direct_down_end = Seq[N: 0]
  for u in N:
    direct_up_end[u] = Seq[child[u].len: 0]
    direct_down_start[u] = Seq[child[u].len: 0]
  for i in M:
    let
      U = hld.lca(S[i], T[i])
      (S, T) = (S[i], T[i])
    ct_start[S].inc
    ct_end[T].inc
    if U != S and U != T: # ダイレクトでない
      non_direct_start[S].inc
      non_direct_end[T].dec
      doAssert child[U].len == 2
      if hld.lca(child[U][0], T) == U:
        # 0 -> 1
        if direction[U] == -1:
          echo 0;return
        direction[U] = 1
      else:
        # 1 -> 0
        if direction[U] == 1:
          echo 0;return
        direction[U] = -1
    elif S == U: # ダイレクト
      # Sの子孫がT: down方向
      var d = 0
      if child[U].len == 2:
        if hld.lca(child[U][0], T) == U: d = 1
      # Tはchild[U][d]の子孫である
      direct_down_start[U][d].inc
      direct_down_end[U].inc
    elif T == U:
      # Tの子孫がS: up方向
      var d = 0
      if child[U].len == 2:
        if hld.lca(child[U][0], S) == U: d = 1
      # Sはchild[U][d]の子孫である
      direct_up_start[U].inc
      direct_up_end[U][d].inc
    else:
      doAssert false
  var ct_sum = Seq[N: 0]
  proc dfs(u:int):seq[mint] =
    ct_sum[u] = ct_start[u] - ct_end[u]
    var a:seq[seq[mint]]
    for c in child[u]:
      a.add dfs(c)
      ct_sum[u] += ct_sum[c]
    result = Seq[K + 1: mint(0)]
    for k in 0 .. K:
      var k1 = k # 実際のりんごの数
      # ノードに入ったらuで終わるものを終わらせる
      k1 -= non_direct_end[u]
      k1 -= direct_down_end[u]
      if k1 < 0: result[k] = 0
      elif k + ct_sum[u] notin 0 .. K:
        # 出る時にk + ct_sum[u]になるのでこれがかごに収まらないとだめ
        result[k] = 0
      else:
        proc go_down(p:int, k1: var int, d: var mint) =
          # child[u]方向に下るのでdirect_down_start[u][p]を足す
          k1 += direct_down_start[u][p]
          if k1 notin 0 .. K: d = 0; return
          d *= a[p][k1]
          # child[u][p]配下のものを全部処理
          k1 += ct_sum[child[u][p]]
          if k1 notin 0 .. K: d = 0; return
          # ここで辺を移動
          # 戻ってきたらdirect_up_end[u][p]を足す
          k1 -= direct_up_end[u][p]
          if k1 notin 0 .. K: d = 0; return
        #  k1個のりんごを持っている
        if child[u].len == 0:
          # 子供がいないなら何もしない
          result[k] += 1
        elif child[u].len == 1:
          # 子供が1つ：ダイレクトに
          block:
            var
              k1 = k1
              d = mint(1)
            go_down(0, k1, d)
            result[k] += d
        elif child[u].len == 2:
          # 子供が2つ
          if direction[u] in [0, 1]:
            # 0 -> 1方向の移動
            var
              k1 = k1
              d = mint(1)
            for p in [0, 1]:
              go_down(p, k1, d)
            result[k] += d
          if direction[u] in [0, -1]:
            # 1 -> 0方向の移動
            var
              k1 = k1
              d = mint(1)
            for p in [1, 0]:
              go_down(p, k1, d)
            result[k] += d
        else:
          doAssert false
  let a = dfs(0)
  echo a[0]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var P = newSeqWith(N-1, nextInt())
  var S = newSeqWith(M, 0)
  var T = newSeqWith(M, 0)
  for i in 0..<M:
    S[i] = nextInt()
    T[i] = nextInt()
  solve(N, M, K, P, S, T)
else:
  discard

