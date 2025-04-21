import sequtils, strutils, algorithm, times, random
include atcoder/extra/header/chaemon_header
import lib/math/sqrt_int
import atcoder/dsu

const LOCAL = true

const
  time_limit_all = 1.995
  time_limit_SA = time_limit_all

let start_time = epochTime()

randomize(42)

let
  N, M, Q, L, W = nextInt()
  G = newSeqWith(M, nextInt())
var
  lx, rx, ly, ry = newSeq[int]()
for _ in 0 ..< N:
  let a, b, c, d = nextInt()
  lx.add(a)
  rx.add(b)
  ly.add(c)
  ry.add(d)

type Point = object
  x, y:int

type State = object
  score: int # 各点の存在範囲の最小と最大の座標の
  groups: seq[seq[int]]
  group_id: seq[int]

proc getScore(state: State):int =
  result = 0
  for i in state.groups.len:
    var
      min_x, min_y = int.inf
      max_x, max_y = -int.inf
    for j in state.groups[i]:
      min_x.min=lx[j]
      min_y.min=ly[j]
      max_x.max=rx[j]
      max_y.max=ry[j]
    result += max_x - min_x + max_y - min_y

proc dist(a, b:Point):int =
  sqrt_int((a.x - b.x)^2 + (a.y - b.y)^2)

when LOCAL:
  var ans_X, ans_Y = newSeq[int](N)
  for i in N:
    ans_X[i] = nextInt()
    ans_Y[i] = nextInt()

proc query(C:seq[int]):seq[tuple[a, b:int]] =
  echo "? ", len(C), " ", C.join(" ")
  when LOCAL:
    var
      es: seq[tuple[d, u, v:int]]
      id {.global.} : seq[int]
    once:
      id = newSeq[int](N)
    for i, u in C:
      id[u] = i
    for u in C:
      for v in C:
        if u >= v: continue
        let d = sqrt_int((ans_X[u] - ans_X[v])^2 + (ans_Y[u] - ans_Y[v])^2)
        es.add (d, u, v)
    es.sort
    var ds = initDSU(C.len)
    for (d, u, v) in es:
      if not ds.same(id[u], id[v]):
        result.add (u, v)
        ds.merge(id[u], id[v])
  else:
    return newSeqWith(C.len - 1, (nextInt(), nextInt()))

proc answer(groups: seq[seq[int]], edges: seq[seq[tuple[a, b:int]]]) =
  echo "!"
  for i in 0 ..< len(groups):
    echo groups[i].join(" ")
    for e in edges[i]:
      echo e.a, " ", e.b

var pos_x, pos_y: seq[int]

proc solveGreedy(): State =
  # use center of rectangle
  for i in 0 ..< N:
    pos_x.add (lx[i] + rx[i]) div 2
    pos_y.add (ly[i] + ry[i]) div 2
  
  # split cities into groups
  var
    cities = ((0 ..< N).toSeq).sortedByIt((pos_x[it], pos_y[it]))
    start_idx = 0
  result.group_id = newSeq[int](N)
  for g in G:
    for t in start_idx ..< start_idx + g:
      result.group_id[t] = result.groups.len
    result.groups.add(cities[start_idx ..< start_idx + g])
    start_idx += g
  result.score = result.getScore()

#proc solveSimulatedAnnealing(output_greedy: State): State =
#  # 焼きなまし法
#  # 「ある1つの配達先を訪問する順序を、別の場所に入れ替える」操作を繰り返すことで、経路を改善する
#
#  # 貪欲法で求めた解をコピー(これを初期解とする)
#  var state = output_greedy
#
#  # 現在の経路の距離を計算
#  var current_dist = state.score
#
#  # 乱数生成器のシード値を設定
#  # 乱数のシード値は固定のものにしておくと、デバッグがしやすくなります
#  #randomize(41)
#
#  # 山登り法の開始時刻を取得
#  let start_time_SA = epochTime()
#
#  # 制限時間(1.9秒)
#  # 2秒ちょうどまでやるとTLEになるので、1.9秒程度にしておくとよい
#
#  # 開始温度と終了温度
#  const start_temperature = 2e2
#  const end_temperature = 1e0
#
#  # 現在の温度
#  var current_temperature = start_temperature
#  var
#    optimal_state = state
#
#  # 試行回数
#  var
#    iteration = 0
#    current_time = 0.0
#
#  # 山登り法の本体
#  while true:
#    # 現在時刻を取得
#    if (iteration and 0xFF) == 0:
#      current_time = epochTime()
#
#    # 制限時間になったら終了
#    if current_time - start_time_SA >= time_limit_SA or current_time - start_time >= time_limit_all:
#      break
#    
#    # 訪問先が配達先であるようなインデックスの中から、
#    # 「i番目の訪問先をj番目に移動」する操作をランダムに選ぶことで、
#    # ある配達先を訪れる順序を他の配達先の間に変える
#    # 貪欲法で求めた解では、配達先の訪問順序は0-indexedで51番目～100番目であることに注意
#    # (AtCoderオフィス、レストラン50軒、配達先50軒、AtCoderオフィスの順に並んでいる)
#
#    #var neighbor_info = setNeighbor(input, state)
#    var
#      old_state = state
#    when false:
#      setNeighbor(state)
#      if state.dist_sum < optimal_state.dist_sum:
#        optimal_state = state
#
#      # 【穴埋め】操作後の距離が操作前以下なら採用する
#      # 【穴埋め】操作前より悪化していても、確率で採用する(悪化度合いが小さく、温度が高いほど採用されやすい)
#      # 【ヒント】採用確率(0.0以上1.0未満)は exp(float64(current_dist - new_dist) / current_temperature) で計算できる
#      # 【ヒント】rand(1.0) と書くと、0.0以上1.0以下の乱数が得られる
#      # put your code here ##
#      if new_dist <= current_dist or rand(1.0) < exp(float(current_dist - new_dist) / current_temperature):
#        current_dist = state.new_dist
#      else:
#        # 採用されなかったら元に戻す
#        state = old_state.move()
#    else:
#      let target = current_dist - int(ln(rand(1.0)) * current_temperature)
#      # targetを下回ったら即決
#      setNeighbor(state, target)
#      if state.dist_sum < optimal_state.dist_sum:
#        optimal_state = state
#      if state.dist_sum < target:
#        current_dist = state.dist_sum
#      else:
#        state = old_state.move()
#
#    # 試行回数のカウントを増やす
#    # 進行状況を可視化するため、一定回数ごとに現在の試行回数と合計距離を標準エラー出力に出力
#    iteration += 1
#    if iteration mod 100000 == 0:
#      stderr.writeLine "iteration: ", iteration, ", total distance: ", current_dist
#    
#    # 現在の経過時間の割合を計算する
#    let progress = (current_time - start_time_SA) / time_limit_SA
#    # 【穴埋め】温度の更新
#    # 【ヒント】現在の経過時間の割合に対する温度は pow(start_temperature, 1.0 - progress) * pow(end_temperature, progress) で計算できる
#    ## put your code here ##
#    current_temperature = pow(start_temperature, 1.0 - progress) * pow(end_temperature, progress)
#
#    # ここまで穴埋めして実行できるようになったら、
#    # 開始温度(start_temperature)と終了温度(end_temperature)を変えてみて、実行結果がどう変わるかを確認してみましょう
#
#  # 試行回数と合計距離を標準エラー出力に出力
#  stderr.writeLine "--- Result ---"
#  stderr.writeLine "iteration   : ", iteration
#  stderr.writeLine "total distance: ", optimal_state.dist_sum
#
#  return optimal_state




proc get_edges(state:State): seq[seq[tuple[a, b: int]]] =
  var edges = newSeq[seq[tuple[a, b: int]]](M)
  for k in 0 ..< M:
    for i in countup(0, G[k] - 2, 2):
      if i < G[k] - 2:
        let ret = query(state.groups[k][i ..< i + 3])
        edges[k] &= ret
      else:
        edges[k].add (state.groups[k][i], state.groups[k][i + 1])
  return edges

proc main() =
  var state = solveGreedy()

  # output answer
  # get edges from queries
  var edges = state.get_edges()

  answer(state.groups, edges)

if isMainModule:
  main()
