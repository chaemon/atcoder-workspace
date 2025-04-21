import sequtils, strutils, algorithm, times, random
include atcoder/extra/header/chaemon_header
#import lib/math/sqrt_int
import atcoder/dsu

const
  time_limit_all = 1.7
  time_limit_SA = time_limit_all

let start_time = epochTime()
const DEBUG = false

randomize(42)

proc sqrt_int*(s:int):int =
  if s <= 1: return s
  var
    #x0 = s shr 1
    x0 = 1 shl (fastLog2(s) div 2 + 1)
    x1 = (x0 + s div x0) shr 1
  while x1 < x0:
    x0 = x1
    x1 = (x0 + s div x0) shr 1
  return x0

let
  N, M, Q, L, W = nextInt()
  G = newSeqWith(M, nextInt())
var
  lx, rx, ly, ry = newSeq[int]()
for _ in 0 ..< N:
  let a, b, c, d = nextInt()
  lx.add(a); rx.add(b); ly.add(c); ry.add(d)

type Point = tuple[x, y: int]

proc dist(a, b: Point): int =
  sqrt_int((a.x - b.x)^2 + (a.y - b.y)^2)

var
  pos: seq[Point]
  da: seq[seq[int]] # da[x][y]: xとyの距離

proc init() =
  for i in 0 ..< N:
    let
      x = (lx[i] + rx[i]) div 2
      y = (ly[i] + ry[i]) div 2
    pos.add (x, y)
  da = Seq[N, N: int]
  for u in N:
    for v in 0 .. u:
      let d = dist(pos[u], pos[v])
      da[u][v] = d
      da[v][u] = d

proc getGroups(belongs: seq[int]):seq[seq[int]] =
  result = newSeq[seq[int]](M)
  for i in N:
    result[belongs[i]].add i

type State = object
  score: int # 各点の存在範囲の最小と最大の座標の差
  #groups: seq[seq[int]]
  belong: seq[int]

proc calcCenter(state: State):seq[Point] =
  var center = Seq[M: Point]
  for i in N:
    let g = state.belong[i]
    center[g].x += pos[i].x
    center[g].y += pos[i].y
  for g in M:
    center[g].x.div=G[g]
    center[g].y.div=G[g]
  return center



proc getScore(state: State): int =
  result = 0
  # 長方形の二辺の和をコストとする。
  #for i in state.groups.len:
  #  var
  #    min_x, min_y = int.inf
  #    max_x, max_y = -int.inf
  #  for j in state.groups[i]:
  #    min_x.min = lx[j]
  #    min_y.min = ly[j]
  #    max_x.max = rx[j]
  #    max_y.max = ry[j]
  #  result += max_x - min_x + max_y - min_y
  var center = state.calcCenter()
  for i in N:
    result += dist(center[state.belong[i]], pos[i])

when defined(LOCAL):
  static:
    echo "Local"
  var ans = newSeq[Point](N)
  for i in N:
    ans[i].x = nextInt()
    ans[i].y = nextInt()
  import os
  var visualizer_f = open("./visualizer_data.txt", fmWrite)
  for i in N:
    visualizer_f.writeLine(ans[i].x, " ", ans[i].y)


proc query(C: seq[int]): seq[tuple[a, b: int]] =
  echo "? ", len(C), " ", C.join(" ")
  when defined(LOCAL):
    var
      es: seq[tuple[d, u, v: int]]
      id {.global.}: seq[int]
    once:
      id = newSeq[int](N)
    for i, u in C:
      id[u] = i
    for u in C:
      for v in C:
        if u >= v: continue
        let d = sqrt_int((ans[u].x - ans[v].x)^2 + (ans[u].y - ans[v].y)^2)
        es.add (d, u, v)
    es.sort
    var ds = initDSU(C.len)
    for (d, u, v) in es:
      if not ds.same(id[u], id[v]):
        result.add (u, v)
        ds.merge(id[u], id[v])
    doAssert result.len == C.len - 1
  else:
    return newSeqWith(C.len - 1, (nextInt(), nextInt()))

proc answer(groups: seq[seq[int]], edges: seq[seq[tuple[a, b: int]]]) =
  echo "!"
  for i in 0 ..< len(groups):
    echo groups[i].join(" ")
    for e in edges[i]:
      echo e.a, " ", e.b

proc solveGreedy(): State =
  # use center of rectangle
  # split cities into groups
  var
    cities = ((0 ..< N).toSeq).sortedByIt((pos[it]))
    start_idx = 0
    groups: seq[seq[int]]
  result.belong = newSeq[int](N)

  for g in G:
    for t in start_idx ..< start_idx + g:
      result.belong[cities[t]] = groups.len
    groups.add(cities[start_idx ..< start_idx + g])
    start_idx += g
  when DEBUG:
    stderr.writeLine cities.join(",")
  result.score = result.getScore()

proc solveGreedySpanningTreeOrder(): State =
  # citiesを全域木の深さ優先順にする
  var
    cities: seq[int]
    start_idx = 0
    g = Seq[N: seq[int]]
    ds = initDSU(N)
    es = Seq[tuple[w, u, v: int]]
  for u in N:
    for v in u + 1 ..< N:
      es.add (da[u][v], u, v)
  es.sort()
  for (d, u, v) in es:
    if not ds.same(u, v):
      when defined(LOCAL):
        stderr.writeLine "edge: ", d, " ", dist(ans[u], ans[v])
      g[u].add v
      g[v].add u
      ds.merge(u, v)
  proc dfs(u, p: int, h = 0) =
    cities.add u
    # pとの距離が遠い順にする？
    var child = Seq[tuple[d, u: int]]
    for v in g[u]:
      if v == p: continue
      var d = if p != -1: da[v][p] else: 0
      child.add (d, v)
    child.sort(Descending)
    debug child
    for (d, v) in child:
      dfs(v, u, h + 1)

  dfs(0, -1)

  result.belong = newSeq[int](N)
  var groups: seq[seq[int]]
  for g in G:
    for t in start_idx ..< start_idx + g:
      result.belong[cities[t]] = groups.len
    groups.add(cities[start_idx ..< start_idx + g])
    start_idx += g
  when DEBUG:
    stderr.writeLine cities.join(",")
  result.score = result.getScore()

proc sortByMST_DFSorder(group: seq[int]):seq[int] =
  var
    dsu = initDSU(group.len)
    es: seq[tuple[d, i, j:int]]
    g = Seq[group.len: seq[int]]
  for i in group.len:
    for j in i + 1 ..< group.len:
      es.add((da[group[i]][group[j]], i, j))
  es.sort()
  for (d, i, j) in es:
    if dsu.same(i, j): continue
    g[i].add j
    g[j].add i
    dsu.merge(i, j)
    discard
  var ans:seq[int]
  proc dfs(u, p:int) =
    ans.add group[u]
    for v in g[u]:
      if v == p: continue
      dfs(v, u)
  dfs(0, -1)
  return ans

proc solveGreedyBisect(gid, pid:seq[int], one_group:seq[tuple[gid, pid: int]]): State =
  # citiesを全域木の深さ優先順にする
  var
    belong = Seq[N: -1]
  proc f(gid, pid: seq[int]) = # gid: groupのid, pid: 点のid
    var
      gid = gid
    gid.shuffle()
    if gid.len == 1:
      for i in pid.len:
        belong[pid[i]] = gid[0]
    else:
      var
        pid = pid
        xmin, ymin = int.inf
        xmax, ymax = -int.inf
      for i in pid:
        xmin.min=pos[i].x
        xmax.max=pos[i].x
        ymin.min=pos[i].y
        ymax.max=pos[i].y
      let
        dx = xmax - xmin
        dy = ymax - ymin
      stderr.writeLine(dx, " ", dy)
      stderr.writeLine $(gid.mapIt(G[it]))
      if dx > dy: # x順にソート
        pid = pid.sortedByIt(pos[it].x)
      else: # y順にソート
        pid = pid.sortedByIt(pos[it].y)
      var
        s, i = 0
        m:int
      let
        S = pid.len div 2
      while i < gid.len:
        s += G[gid[i]]
        if s >= S:
          m = i + 1
          break
        i.inc
      if m notin 1 .. gid.len - 1:
        m = gid.len - 1
        s = 0
        for i in 0 ..< m:
          s += G[gid[i]]
      f(gid[0 ..< m], pid[0 ..< s])
      f(gid[m .. ^1], pid[s .. ^1])

  f(gid, pid)

  for (gid, pid) in one_group:
    belong[pid] = gid

  result.belong = belong
  debug result.belong
  #result.groups = Seq[M: seq[int]]
  #for u, g in belong:
  #  result.groups[g].add u
  #for i in result.groups.len:
  #  result.groups[i] = sortByMST_DFSorder(result.groups[i])

  result.score = result.getScore()

import std/heapqueue

proc solveGreedyPrim():State =
  var gid = (0 ..< M).toSeq
  gid.shuffle()
  # Prim法で順番に決める
  var
    selected = Seq[N: false]
    s = gid[0 ..< G.len]
    groups = Seq[G.len: seq[int]]
    ct_ans, ct = Seq[G.max + 2: 0]
  for g in G:
    for i in 1 .. g:
      ct_ans[i].inc
  var q = initHeapQueue[tuple[l, u, gi:int]]()
  for gi, u in s:
    q.push((0, u, gi))
  while q.len > 0:
    let (_, u, gi) = q.pop()
    if selected[u]: continue
    # uを追加していいのか？
    let gL = groups[gi].len + 1
    # ct[gL]が1増える
    doAssert ct[gL] <= ct_ans[gL]
    if ct[gL] == ct_ans[gL]: continue
    ct[gL].inc
    groups[gi].add u
    selected[u] = true
    for v in N:
      if selected[v]: continue
      q.push((da[u][v], v, gi))
  groups = groups.sortedByIt(it.len)
  var
    gs_id:seq[tuple[g, i:int]]
    belong = Seq[N: int]
  for i in G.len:
    gs_id.add (G[i], i)
  doAssert ct == ct_ans
  gs_id.sort()
  for gi in gs_id.len:
    doAssert gs_id[gi].g == groups[gi].len
    for u in groups[gi]:
      belong[u] = gs_id[gi].i
  result.belong = belong
  result.score = result.getScore()

type NeighborInfo = object
  old_score: int
  swapped: seq[tuple[i, j: int]]
  discard

proc swap_group(state: var State, i, j: int) = # i, jの所属を入れ替える
  let
    gi = state.belong[i]
    gj = state.belong[j]
  if gi == gj: return
  swap state.belong[i], state.belong[j]
  #block:
  #  let ki = state.groups[gi].find(i)
  #  doAssert ki != -1
  #  doAssert state.groups[gi][ki] == i
  #  state.groups[gi].delete(ki)
  #  let kj = state.groups[gj].find(j)
  #  doAssert kj != -1
  #  doAssert state.groups[gj][kj] == j
  #  state.groups[gj].delete(kj)

  #  state.groups[gi].add j
  #  state.groups[gj].add i

proc setNeighbor(state: var State): NeighborInfo =
  result.old_score = state.score
  var center = state.calcCenter()
  var
    max_dist = -int.inf
    max_i = -1
  if rand(0 .. 0) == 0:
    max_i = rand(0 ..< N)
    max_dist = dist(center[state.belong[max_i]], pos[max_i])
  else:
    for i in N:
      let d = dist(center[state.belong[i]], pos[i])
      if max_dist < d:
        max_dist = d
        max_i = i

  let gi = state.belong[max_i]
  # max_iとjを入れ替える
  var
    max_diff = -int.inf
    max_j = -1
  for j in N:
    let gj = state.belong[j]
    if gj == gi: continue
    # max_i in gi
    # j in gj
    # max_i, jの所属グループを入れ替えた場合の差分 (入れ替え前) - (入れ替え後)
    let diff =  (max_dist + dist(pos[j], center[gj])) - (dist(pos[max_i], center[gj]) + dist(pos[j], center[gi]))
    if diff > max_diff:
      max_diff = diff
      max_j = j
  if max_diff > 0:
    debug max_dist, max_diff, max_i, max_j
  state.swap_group(max_i, max_j)
  result.swapped.add (max_i, max_j)
  state.score = state.getScore()
  debug result.old_score, state.score

proc resetNeighbor(state: var State, info: NeighborInfo) =
  for i in countdown(info.swapped.len - 1, 0):
    let (i, j) = info.swapped[i]
    state.swap_group(i, j)
    discard
  state.score = info.old_score


proc solveSimulatedAnnealing(initial_state: State): State =
  # 焼きなまし法
  # 「ある1つの配達先を訪問する順序を、別の場所に入れ替える」操作を繰り返すことで、経路を改善する

  # 貪欲法で求めた解をコピー(これを初期解とする)
  var state = initial_state

  # 現在の経路の距離を計算
  var current_dist = state.score

  # 乱数生成器のシード値を設定
  # 乱数のシード値は固定のものにしておくと、デバッグがしやすくなります
  #randomize(41)

  # 山登り法の開始時刻を取得
  let start_time_SA = epochTime()

  # 制限時間(1.9秒)
  # 2秒ちょうどまでやるとTLEになるので、1.9秒程度にしておくとよい

  # 開始温度と終了温度
  const start_temperature = 2e2
  const end_temperature = 1e0

  # 現在の温度
  var current_temperature = start_temperature
  var
    optimal_state = state

  # 試行回数
  var
    iteration = 0
    current_time = 0.0

  # 山登り法の本体
  while true:
    # 現在時刻を取得
    #if (iteration and 0xFF) == 0: current_time = epochTime()
    current_time = epochTime()

    # 制限時間になったら終了
    if current_time - start_time_SA >= time_limit_SA or current_time -
        start_time >= time_limit_all:
      break

    # 訪問先が配達先であるようなインデックスの中から、
    # 「i番目の訪問先をj番目に移動」する操作をランダムに選ぶことで、
    # ある配達先を訪れる順序を他の配達先の間に変える
    # 貪欲法で求めた解では、配達先の訪問順序は0-indexedで51番目～100番目であることに注意
    # (AtCoderオフィス、レストラン50軒、配達先50軒、AtCoderオフィスの順に並んでいる)

    #var neighbor_info = setNeighbor(input, state)
    var
      old_state = state
    when true: # 通常のやきなまし
      let info = setNeighbor(state)
      if state.score < optimal_state.score:
        optimal_state = state
        when DEBUG:
          stderr.writeLine "found: ", optimal_state.score

      if state.score <= current_dist or rand(1.0) < exp(float(current_dist -
          state.score) / current_temperature):
        current_dist = state.score
      else:
        # 採用されなかったら元に戻す
        #state = old_state.move()
        state.resetNeighbor(info)
    else:
      let target = current_dist - int(ln(rand(1.0)) * current_temperature)
      # targetを下回ったら即決
      setNeighbor(state, target)
      if state.dist_sum < optimal_state.dist_sum:
        optimal_state = state
      if state.dist_sum < target:
        current_dist = state.dist_sum
      else:
        state = old_state.move()

    # 試行回数のカウントを増やす
    # 進行状況を可視化するため、一定回数ごとに現在の試行回数と合計距離を標準エラー出力に出力
    iteration += 1
    when DEBUG:
      if iteration mod 100000 == 0:
        stderr.writeLine "iteration: ", iteration, ", total distance: ", current_dist

    # 現在の経過時間の割合を計算する
    let progress = (current_time - start_time_SA) / time_limit_SA
    ## put your code here ##
    current_temperature = pow(start_temperature, 1.0 - progress) * pow(
        end_temperature, progress)

    # 開始温度(start_temperature)と終了温度(end_temperature)を変えてみて、実行結果がどう変わるかを確認してみましょう

  # 試行回数と合計距離を標準エラー出力に出力
  when DEBUG:
    stderr.writeLine "--- Result ---"
    stderr.writeLine "iteration   : ", iteration
    stderr.writeLine "total distance: ", optimal_state.score

  return optimal_state

proc get_edges(state: State, groups: seq[seq[int]]): seq[seq[tuple[a, b: int]]] =
  var
    edges = newSeq[seq[tuple[a, b: int]]](M)
  for k in 0 ..< M:
    let gl = groups[k].len
    var i = 0
    while true:
      if i >= gl - 1: break
      let t = min(i + L, gl)
      # i ..< t
      if t - i >= 3:
        let ret = query(groups[k][i ..< t])
        edges[k] &= ret
      else:
        edges[k].add (groups[k][i], groups[k][i + 1])
        break
      i += L - 1
  return edges



proc main() =
  init()
  var
    gid, pid: seq[int]
    v: seq[tuple[W, i: int]]
  for i in N:
    let W = max(rx[i] - lx[i], ry[i] - ly[i])
    v.add (W, i)
  v.sort(Descending)
  var
    vi = 0
    one_group: seq[tuple[gid, pid: int]]
  for g in 0 ..< M:
    if G[g] == 1:
      one_group.add (g, v[vi].i)
      vi.inc
    else:
      gid.add g
  for i in vi ..< N:
    pid.add v[i].i
  var
    #state = solveGreedy()
    #state = solveGreedySpanningTreeOrder()
    state = solveGreedyBisect(gid, pid, one_group)
    #state = solveGreedyPrim()

  #state = solveSimulatedAnnealing(state)

  # output answer
  # get edges from queries

  var groups = state.belong.getGroups()
  for i in groups.len:
    groups[i] = sortByMST_DFSorder(groups[i])

  var edges = state.get_edges(groups)
  answer(groups, edges)

if isMainModule:
  main()
