## @file a03_simulated_annealing.nim
## @brief
## 今いる点から最も近いレストランに行くことを50回繰り返し、その後今いる点から最も近い目的地に行くことを50回繰り返す解法プログラム

{.checks:off.}

#include lib/header/chaemon_header
import atcoder/header

const DEBUG = false

import math, random, sequtils, times
import algorithm

const INF = int.inf

const
  time_limit_all = 1.998
  #time_limit_all = 10.0
  #time_limit_SA = 0.66
  time_limit_SA = time_limit_all
  ORDER_COUNT = 1000
  PICKUP_COUNT = 50

let start_time = epochTime()

randomize(42)

## @brief 2次元座標上の点を表す型
type Point = object
  x, y: int

## @brief 2次元座標上の点を表す型のコンストラクタ
proc newPoint(x, y: int): Point =
  result.x = x
  result.y = y

## @brief 2点間のマンハッタン距離を計算する
## @param p1 距離を計算する点1
## @param p2 距離を計算する点2
## @return 2点間のマンハッタン距離
proc dist(p1, p2: Point): int =
  abs(p1.x - p2.x) + abs(p1.y - p2.y)

## @brief 入力データを表す型
type Input = ref object
  ## @brief レストランの数 (=1000)
  order_count: int
  ## @brief 選択する必要のある注文の数 (=50)
  pickup_count: int
  ## @brief AtCoderオフィスの座標 (=(400, 400))
  office: Point
  ## @brief レストランの座標の配列
  restaurants: seq[Point]
  ## @brief 目的地の座標の配列
  destinations: seq[Point]
  pos: seq[Point]

## @brief 入力データを読み込む
## @return 読み込んだ入力データ
proc readInput(): Input =
  var input = Input()

  input.order_count = ORDER_COUNT
  input.pickup_count = PICKUP_COUNT
  input.office = newPoint(400, 400)
  input.restaurants = newSeq[Point]()
  input.destinations = newSeq[Point]()

  for i in 0 ..< input.order_count:
    let a, b, c, d = nextInt()
    input.restaurants.add(newPoint(a, b))
    input.destinations.add(newPoint(c, d))

  return input

type State = object
  orders: seq[int]
  #route: seq[Point]
  route_id: seq[int]
  dist_sum: int

proc `<`(l, r:State):bool =
  l.dist_sum < r.dist_sum

var da: array[ORDER_COUNT * 2 + 1, array[ORDER_COUNT * 2 + 1, int16]]

## @brief 出力データを表す型
type Output = ref object
  ## @brief 移動距離の合計
  ## @brief 選択した注文のリスト
  state: State
  #orders: seq[int]
  ## @brief 配達ルート
  #route: seq[Point]
  #route_id: seq[tuple[t, i:int]]

## @brief 出力データを構築する
## @param orders 選択した注文のリスト
## @param route 配達ルート
proc newOutput(state:State): Output =
  var output = Output(state: state)

  output.state.dist_sum = 0
  for i in 0 ..< state.route_id.high:
    output.state.dist_sum += da[state.route_id[i]][state.route_id[i + 1]]

  return output

## @brief 解を出力する
proc print(input: Input, output: Output) =
  # 選択した注文の集合を出力する
  stdout.write output.state.orders.len

  for i in 0 ..< output.state.orders.len:
    # 0-indexed -> 1-indexedに変更
    stdout.write " ", output.state.orders[i] + 1

  stdout.writeLine ""

  # 配達ルートを出力する
  stdout.write output.state.route_id.len

  for i in 0 ..< output.state.route_id.len:
    let P = input.pos[output.state.route_id[i]]
    stdout.write " ", P.x, " ", P.y

  stdout.writeLine ""

## @brief 問題を解く関数（この関数を実装していきます）
## @param input 入力データ
## @return 出力データ
proc solveGreedy(input: Input, center: Point = input.office): Output =
  # 貪欲その2
  # 以下を順に実行するプログラム
  # 1.オフィスから距離office_dist以下の注文だけを候補にする
  # 2.高橋君は最初オフィスから出発する
  # 3.訪問したレストランが50軒に達するまで、今いる場所から一番近いレストランに移動することを繰り返す
  # 4.受けた注文を捌ききるまで、今いる場所から一番近い配達先に移動することを繰り返す
  # 5.オフィスに帰る

  var
    candidates = newSeq[int]()
    orders = newSeq[int]()
    route_id = newSeq[int]()

  # 1.オフィスから距離400以下の注文だけを候補にする
  #let office_dist = 300
  #for i in 0 ..< input.order_count:
  #  if input.office.dist(input.restaurants[i]) <= office_dist and input.office.dist(input.destinations[i]) <= office_dist:
  #    candidates.add(i)
  #    オフィスからレストランとdesinationまでの距離の最大値が小さい順に選ぶ
  var cv: seq[tuple[d, i:int]]
  for i in 0 ..< input.order_count:
    let
      d1 = center.dist(input.restaurants[i])
      d2 = center.dist(input.destinations[i])
    cv.add (max(d1, d2), i)
  cv.sort()
  
  for i in 0 ..< 83:
    candidates.add cv[i].i

  # 2.オフィスからスタート
  route_id.add(2 * ORDER_COUNT)
  var current_position = input.office # 現在地
  var total_dist = 0          # 総移動距離

  # 3.訪問したレストランが50軒に達するまで、今いる場所から一番近いレストランに移動することを繰り返す

  # 同じレストランを2回訪れてはいけないので、訪問済みのレストランを記録する
  var visited_restaurant = newSeqWith(input.order_count, false)

  # pickup_count(=50)回ループ
  for i in 0 ..< input.pickup_count:
    # レストランを全探索して、最も近いレストランを探す
    var nearest_restaurant = 0  # レストランの番号
    var min_dist = INF    # 最も近いレストランの距離

    # 候補にした注文だけを調べる
    for j in candidates:
      # 既に訪れていたらスキップ
      if visited_restaurant[j]:
        continue

      # 最短距離が更新されたら記録
      let distance = current_position.dist(input.restaurants[j])

      if distance < min_dist:
        min_dist = distance
        nearest_restaurant = j

    # 最も近いレストラン(nearest_restaurant)に移動する
    # 現在位置を最も近いレストランの位置に更新
    current_position = input.restaurants[nearest_restaurant]

    # 注文の集合に選んだレストランを追加
    orders.add(nearest_restaurant)

    # 配達ルートに現在の位置を追加
    #route.add(current_position)
    #route_id.add((0, nearest_restaurant))
    route_id.add(nearest_restaurant)

    # 訪問済みレストランの配列にtrueをセット
    visited_restaurant[nearest_restaurant] = true

    # 総移動距離の更新
    total_dist += min_dist

    # デバッグしやすいよう、標準エラー出力にレストランを出力
    # 標準エラー出力はデバッグに有効なので、AHCでは積極的に活用していきましょう
    let restaurant_pos = input.restaurants[nearest_restaurant]
    #when DEBUG:
    #  stderr.writeLine i, "番目のレストラン: p_", nearest_restaurant, " = (", restaurant_pos.x, ", ", restaurant_pos.y, ")"

  # 4.受けた注文を捌ききるまで、今いる場所から一番近い配達先に移動することを繰り返す

  # 行かなければいけない配達先のリスト
  # ordersは最終的に出力しなければならないので、ここでコピーを作成しておく
  # 配達先を訪問したらこのリストから1つずつ削除していく
  var destinations = orders

  # pickup_count(=50)回ループ
  for i in 0 ..< input.pickup_count:
    # 配達先を全探索して、最も近い配達先を探す
    var nearest_index = 0                  # 配達先リストのインデックス
    var nearest_destination = destinations[nearest_index]  # 配達先の番号
    var min_dist = INF                # 最も近い配達先の距離

    # 0～999まで全探索するのではなく、50個のレストランに対応した配達先を全探索することに注意
    for j in 0 ..< destinations.len:
      # 最短距離が更新されたら記録
      let distance = current_position.dist(input.destinations[destinations[j]])

      if distance < min_dist:
        min_dist = distance
        nearest_index = j
        nearest_destination = destinations[j]

    # 最も近い配達先(nearest_destination)に移動する
    # 現在位置を最も近い配達先の位置に更新
    current_position = input.destinations[nearest_destination]

    # 配達ルートに現在の位置を追加
    #route.add(current_position)
    route_id.add(nearest_destination + ORDER_COUNT)

    # 配達先のリストから削除
    destinations.del(nearest_index)

    # 総移動距離の更新
    total_dist += min_dist

    # デバッグしやすいよう、標準エラー出力に配達先を出力
    let destination_pos = input.destinations[nearest_destination]
    # when DEBUG:
    #  stderr.writeLine i, "番目の配達先: q_", nearest_destination, " = (", destination_pos.x, ", ", destination_pos.y, ")"

  # 5.オフィスに戻る
  #route.add(input.office)
  route_id.add(2 * ORDER_COUNT)
  total_dist += current_position.dist(input.office)

  # 合計距離を標準エラー出力に出力
  # 標準エラー出力はデバッグに有効なので、AHCでは積極的に活用していきましょう
  when DEBUG:
    stderr.writeLine "total distance: ", total_dist

  return newOutput(State(orders:orders, route_id:route_id))


## @brief 経路の距離を計算する
## @param route 経路
## @return 経路の距離
proc getDistance(input:Input, route_id: seq[int]): int =
  var ds = 0
  for i in 0 ..< route_id.high:
    ds += da[route_id[i]][route_id[i + 1]]
  return ds

var route_numbers: array[ORDER_COUNT, tuple[src, dst: int]]

proc updateIndexTable(state: State) =
  for j in 1 .. state.route_id.len - 2:
    let v = state.route_id[j]
    if v < ORDER_COUNT:
      route_numbers[v].src = j
    else:
      route_numbers[v - ORDER_COUNT].dst = j

proc delete_index(state: var State, i:int) =
  #state.route.delete(i)
  state.route_id.delete(i)

# たぶん使っていない
proc setNeighbor(input: Input, state: var State) =
  when DEBUG:
    let start_dist = input.getDistance(state.route_id)
  updateIndexTable(state)
  let
    i = state.orders.sample
    (srci, dsti) = route_numbers[i]
  #stderr.write "i = ", i, "\n"
  # dstiを削除
  #let point_to_move = state.route[dsti]
  state.delete_index(dsti)
  when DEBUG:
    let old_dist = input.getDistance(state.route_id)
  var
    dmin = INF
    dsti2 = -1
  #for j in srci + 1 ..< state.route.len:
  #  # j - 1, jの間に入れる
  #  let d = dist(state.route[j - 1], point_to_move) + dist(point_to_move, state.route[j]) - dist(state.route[j - 1], state.route[j])
  #  if dmin > d:
  #    dmin = d
  #    dsti2 = j
  # srci + 1 .. ^2の中で最適なところに挿入
  dsti2 = rand(srci + 1 ..< state.route_id.len)
  #state.route.insert(point_to_move, dsti2)
  state.route_id.insert(i + ORDER_COUNT, dsti2)
  when DEBUG:
    let new_dist = input.getDistance(state.route_id)
    stderr.write "srci = ", srci, "\n"
    stderr.write "new_dist - start_dist = ", new_dist - start_dist, " dmin = ", dmin, "\n"

  # 訪問先が配達先であるようなインデックスの中から i, j をランダムに選ぶ
  #let i = rand(input.pickup_count - 1) + input.pickup_count + 1
  #let j = rand(input.pickup_count - 1) + input.pickup_count + 1

  ## i番目の訪問先をj番目に移動する操作を行う
  #let point_to_move = state.route[i]
  #state.route.delete(i)
  #state.route.insert(point_to_move, j)
  #let id_to_move = state.route_id[i]
  #state.route_id.delete(i)
  #state.route_id.insert(id_to_move, j)
  return

proc setNeighbor2(input: Input, state: var State, target = -INF) =
  updateIndexTable(state)
  # ランダムに選ぶ
  var del_i:int
  proc calc_del_diff(state: State, del_i: int):int {.inline.} =
    let (srci, dsti) = route_numbers[del_i]
    var diff = 0
    if src_i + 1 == dst_i:
      #diff = dist(state.route[src_i - 1], state.route[src_i]) + dist(state.route[src_i], state.route[src_i + 1]) + dist(state.route[dst_i], state.route[dst_i + 1]) - dist(state.route[src_i - 1], state.route[dst_i + 1])
      diff = da[state.route_id[src_i - 1]][state.route_id[src_i]] + da[state.route_id[src_i]][state.route_id[src_i + 1]] + da[state.route_id[dst_i]][state.route_id[dst_i + 1]] - da[state.route_id[src_i - 1]][state.route_id[dst_i + 1]]
    else:
      #diff += dist(state.route[src_i - 1], state.route[src_i]) + dist(state.route[src_i], state.route[src_i + 1]) - dist(state.route[src_i - 1], state.route[src_i + 1])
      diff += da[state.route_id[src_i - 1]][state.route_id[src_i]] + da[state.route_id[src_i]][state.route_id[src_i + 1]] - da[state.route_id[src_i - 1]][state.route_id[src_i + 1]]
      #diff += dist(state.route[dst_i - 1], state.route[dst_i]) + dist(state.route[dst_i], state.route[dst_i + 1]) - dist(state.route[dst_i - 1], state.route[dst_i + 1])
      diff += da[state.route_id[dst_i - 1]][state.route_id[dst_i]] + da[state.route_id[dst_i]][state.route_id[dst_i + 1]] - da[state.route_id[dst_i - 1]][state.route_id[dst_i + 1]]
    return diff
 
  if rand(1.0) < 0.33:
    del_i = state.orders.sample
  else:
    #注文iの選び方をそれを除くと最も改善するものに変更
    del_i = -1
    var
      max_diff = -INF
    for i in state.orders:
      let diff = state.calc_del_diff(i)
      if diff > max_diff:
        max_diff = diff
        del_i = i
  let
    old_dist = state.dist_sum
    del_diff = state.calc_del_diff(del_i)
  let (srci, dsti) = route_numbers[del_i]
  # 注文del_iを削除
  assert srci < dsti
  state.delete_index(dsti)
  state.delete_index(srci)
  state.orders.delete(state.orders.find(del_i))
  let current_dist_sum = old_dist - del_diff
  when DEBUG:
    var new_distance = input.getDistance(state.route_id)
    doAssert new_distance == current_dist_sum
  var
    min_x, min_y = INF
    max_x, max_y = -INF
  for i in 0 ..< state.route_id.len:
    let P = input.pos[state.route_id[i]]
    min_x.min=P.x
    max_x.max=P.x
    min_y.min=P.y
    max_y.max=P.y
  var add_i: int
  while true:
    add_i = rand(0 ..< input.order_count)
    if add_i in state.orders:
      continue
    # add_iを追加したコストを計算
    proc calc_cost(add_i:int):int =
      let
        src_p = input.restaurants[add_i]
        dst_p = input.restaurants[add_i]
      let
        dx = max([src_p.x, dst_p.x, max_x]) - min([src_p.x, dst_p.x, min_x])
        dy = max([src_p.y, dst_p.y, max_y]) - min([src_p.y, dst_p.y, min_y])
      return 2 * (dx + dy - (max_x - min_x) - (max_y - min_y))
    let c = calc_cost(add_i)
    if current_dist_sum + c > target:
      continue
    break
  state.orders.add(add_i)
  var
    min_src_i:int
    min_src_diff = INF
    #v = newSeq[tuple[d, si, di: int]]()
    v: tuple[d, si, di: int]
    src_p = add_i
    dst_p = add_i + ORDER_COUNT
  v.d = INF
  # 注文add_iを挿入
  for i in 1 ..< state.route_id.len:
    # i - 1, iの間に入れる
    # ダイレクト
    let dist_old = da[state.route_id[i - 1]][state.route_id[i]]
    block:
      let d:int = da[state.route_id[i - 1]][src_p] + da[src_p][dst_p] + da[dst_p][state.route_id[i]] - dist_old
      if v.d > d:
        v = (d, i, i)
      #v.add (d, i, i)
    if i > 1:
      let d:int = min_src_diff + da[state.route_id[i - 1]][dst_p] + da[dst_p][state.route_id[i]] - dist_old
      if v.d > d:
        v = (d, min_src_i, i)
        # targetを下回ったらbreak (いまいち)
        #if current_dist_sum + d < target - 500:
        #  break
      #v.add (d, min_src_i, i)
    let d = da[state.route_id[i - 1]][src_p] + da[src_p][state.route_id[i]] - dist_old
    if d <= min_src_diff:
      min_src_diff = d
      min_src_i = i
  #v.sort
  block:
    let (d, src_i, dst_i) = v
    # dst_iを挿入
    #state.route.insert(dst_p, dst_i)
    state.route_id.insert(dst_p, dst_i)
    #state.route.insert(src_p, src_i)
    state.route_id.insert(src_p, src_i)
    #state.dist_sum = getDistance(state.route)
    state.dist_sum = current_dist_sum + d
    when DEBUG:
      doAssert getDistance(state.route) == current_dist_sum + d

## @brief 配達先の訪問順序を焼きなまし法で改善する関数（この関数を実装していきます）
## @param input 入力データ
## @param output_greedy 貪欲法で求めた出力データ
## @return 出力データ
proc solveSimulatedAnnealing(input: Input, output_greedy: Output): Output =
  # 焼きなまし法
  # 「ある1つの配達先を訪問する順序を、別の場所に入れ替える」操作を繰り返すことで、経路を改善する

  # 貪欲法で求めた解をコピー(これを初期解とする)
  var state = output_greedy.state

  # 現在の経路の距離を計算
  var current_dist = input.getDistance(state.route_id)

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
  var iteration = 0

  # 山登り法の本体
  while true:
    # 現在時刻を取得
    let current_time = epochTime()

    # 制限時間になったら終了
    if current_time - start_time_SA >= time_limit_SA or current_time - start_time >= time_limit_all:
      break
    
    # 訪問先が配達先であるようなインデックスの中から、
    # 「i番目の訪問先をj番目に移動」する操作をランダムに選ぶことで、
    # ある配達先を訪れる順序を他の配達先の間に変える
    # 貪欲法で求めた解では、配達先の訪問順序は0-indexedで51番目～100番目であることに注意
    # (AtCoderオフィス、レストラン50軒、配達先50軒、AtCoderオフィスの順に並んでいる)

    #var neighbor_info = setNeighbor(input, state)
    var
      old_state = state
    when false:
      setNeighbor2(input, state)
      if state.dist_sum < optimal_state.dist_sum:
        optimal_state = state

      # 【穴埋め】操作後の距離が操作前以下なら採用する
      # 【穴埋め】操作前より悪化していても、確率で採用する(悪化度合いが小さく、温度が高いほど採用されやすい)
      # 【ヒント】採用確率(0.0以上1.0未満)は exp(float64(current_dist - new_dist) / current_temperature) で計算できる
      # 【ヒント】rand(1.0) と書くと、0.0以上1.0以下の乱数が得られる
      # put your code here ##
      if new_dist <= current_dist or rand(1.0) < exp(float(current_dist - new_dist) / current_temperature):
        current_dist = state.new_dist
      else:
        # 採用されなかったら元に戻す
        state = old_state.move()
    else:
      let target = current_dist - int(ln(rand(1.0)) * current_temperature)
      # targetを下回ったら即決
      setNeighbor2(input, state, target)
      if state.dist_sum < optimal_state.dist_sum:
        optimal_state = state
      if state.dist_sum < target:
        current_dist = state.dist_sum
      else:
        state = old_state.move()

    # 試行回数のカウントを増やす
    # 進行状況を可視化するため、一定回数ごとに現在の試行回数と合計距離を標準エラー出力に出力
    iteration += 1
    if iteration mod 100000 == 0:
      stderr.writeLine "iteration: ", iteration, ", total distance: ", current_dist
    
    # 現在の経過時間の割合を計算する
    let progress = (current_time - start_time_SA) / time_limit_SA
    # 【穴埋め】温度の更新
    # 【ヒント】現在の経過時間の割合に対する温度は pow(start_temperature, 1.0 - progress) * pow(end_temperature, progress) で計算できる
    ## put your code here ##
    current_temperature = pow(start_temperature, 1.0 - progress) * pow(end_temperature, progress)

    # ここまで穴埋めして実行できるようになったら、
    # 開始温度(start_temperature)と終了温度(end_temperature)を変えてみて、実行結果がどう変わるかを確認してみましょう

  # 試行回数と合計距離を標準エラー出力に出力
  stderr.writeLine "--- Result ---"
  stderr.writeLine "iteration   : ", iteration
  stderr.writeLine "total distance: ", optimal_state.dist_sum

  return newOutput(optimal_state)


#proc solveBeamSearch(input: Input, initial_states: seq[State]): Output =
#  const BEAM_WIDTH = 20
#  var
#    states = initial_states
#    opt_val = INF
#    opt_state: State
#    iterations = 0
#  while true:
#    iterations.inc
#    var
#      next_states: seq[State]
#    #when DEBUG:
#    #  var ds: seq[int]
#    for state in states:
#      #when DEBUG:
#      #  ds.add state.dist_sum
#      for _ in 0 ..< 3:
#        var nstate = state
#        input.setNeighbor2(nstate)
#        if nstate.dist_sum < opt_val:
#          opt_val = nstate.dist_sum
#          opt_state = nstate
#          #when DEBUG:
#          #  stderr.writeLine "found: ", opt_val
#        next_states.add nstate
#    #when DEBUG:
#    #  stderr.writeLine "ds = ", ds
#    if next_states.len > BEAM_WIDTH:
#      when DEBUG:
#        if iterations mod 10000 == 0:
#          block:
#            var ds: seq[int]
#            for i in next_states.len:
#              ds.add next_states[i].dist_sum
#            stderr.write "before: " 
#            stderr.write ds, "\n"
#      next_states.nth_element(BEAM_WIDTH)
#      when DEBUG:
#        if iterations mod 10000 == 0:
#          block:
#            var ds: seq[int]
#            for i in next_states.len:
#              ds.add next_states[i].dist_sum
#            stderr.write "after: " 
#            stderr.write ds, "\n"
#      next_states.setLen(BEAM_WIDTH)
#    states = next_states.move()

const USE_BEAM = false

proc main() =
  # 入力データを読み込む
  var input = readInput()
  #route_numbers = newSeq[tuple[src, dst:int]](input.order_count)
  input.pos = newSeq[Point](2 * ORDER_COUNT + 1)
  for i in 0 ..< input.order_count:
    input.pos[i] = input.restaurants[i]
    input.pos[i + ORDER_COUNT] = input.destinations[i]
  input.pos[ORDER_COUNT * 2] = input.office

  for i in 0 .. 2 * ORDER_COUNT:
    for j in 0 ..< i:
      let d = dist(input.pos[i], input.pos[j])
      da[i][j] = int16(d)
      da[j][i] = int16(d)

  when USE_BEAM:
    var initial_states: seq[State]
    # 問題を解く
    for x in countup(300, 500, 100):
      for y in countup(300, 500, 100):
        var output_greedy = solveGreedy(input, newPoint(x, y))
        initial_states.add output_greedy.state
    var output = solveBeamSearch(input, initial_states)
  else:
    var
      optimal_dist_sum = INF
      optimal: Output
    while true:
      let current_time = epochTime()

      # 制限時間になったら終了
      if current_time - start_time >= time_limit_all:
        break

      #let x0, y0 = rand(300 .. 500)
      let x0, y0 = 400
      stderr.writeLine x0, " ", y0
      #var output_greedy = solveGreedy(input, newPoint(400, 400))
      var output_greedy = solveGreedy(input, newPoint(x0, y0))
      var output = solveSimulatedAnnealing(input, output_greedy)
      if optimal_dist_sum > output.state.dist_sum:
        optimal_dist_sum = output.state.dist_sum
        optimal = output
    stderr.writeLine "final distance: ", optimal.state.dist_sum
  # 解を出力する
    print(input, optimal)


when isMainModule:
  main()

