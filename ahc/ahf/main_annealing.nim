## @file a03_simulated_annealing.nim
## @brief
## 今いる点から最も近いレストランに行くことを50回繰り返し、その後今いる点から最も近い目的地に行くことを50回繰り返す解法プログラム

const DO_CHECK = false;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
#import atcoder/header


import math, random, tables, sequtils, times
import algorithm



const INF = int.inf

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

## @brief 入力データを読み込む
## @return 読み込んだ入力データ
proc readInput(): Input =
  var input = Input()

  input.order_count = 1000
  input.pickup_count = 50
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
  route: seq[Point]
  route_id: seq[tuple[t, i: int]]

## @brief 出力データを表す型
type Output = ref object
  ## @brief 移動距離の合計
  dist_sum: int
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

  output.dist_sum = 0
  for i in 0 ..< state.route.high:
    output.dist_sum += dist(state.route[i], state.route[i + 1])

  return output

## @brief 解を出力する
proc print(output: Output) =
  # 選択した注文の集合を出力する
  stdout.write output.state.orders.len

  for i in 0 ..< output.state.orders.len:
    # 0-indexed -> 1-indexedに変更
    stdout.write " ", output.state.orders[i] + 1

  stdout.writeLine ""

  # 配達ルートを出力する
  stdout.write output.state.route.len

  for i in 0 ..< output.state.route.len:
    stdout.write " ", output.state.route[i].x, " ", output.state.route[i].y

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
    route = newSeq[Point]()
    route_id = newSeq[tuple[t, i: int]]()
  # t = 0: レストラン
  # t = 1: destination
  # t = 2: オフィス


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
  route.add(input.office)
  route_id.add((2, -2025))
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
    route.add(current_position)
    route_id.add((0, nearest_restaurant))

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
    route.add(current_position)
    route_id.add((1, nearest_destination))

    # 配達先のリストから削除
    destinations.del(nearest_index)

    # 総移動距離の更新
    total_dist += min_dist

    # デバッグしやすいよう、標準エラー出力に配達先を出力
    let destination_pos = input.destinations[nearest_destination]
    # when DEBUG:
    #  stderr.writeLine i, "番目の配達先: q_", nearest_destination, " = (", destination_pos.x, ", ", destination_pos.y, ")"

  # 5.オフィスに戻る
  route.add(input.office)
  route_id.add((2, -2025))
  total_dist += current_position.dist(input.office)

  # 合計距離を標準エラー出力に出力
  # 標準エラー出力はデバッグに有効なので、AHCでは積極的に活用していきましょう
  when DEBUG:
    stderr.writeLine "total distance: ", total_dist

  return newOutput(State(orders:orders, route:route, route_id:route_id))

## @brief 経路の距離を計算する
## @param route 経路
## @return 経路の距離
proc getDistance(route: seq[Point]): int =
  var dist = 0
  for i in 0 ..< route.high:
    dist += route[i].dist(route[i + 1])
  return dist

type NeighborInfo = object
  state: State

proc getIndexTable(state: State): Table[int, tuple[src, dst:int]] =
  var
    a = initTable[int, tuple[src, dst: int]]()
  for j, (t, i) in state.route_id:
    if t notin [0, 1]: continue
    if i notin a: a[i] = (-1, -1)
    case t
      of 0:
        a[i].src = j
      of 1:
        a[i].dst = j
      else:
        doAssert false
  return a

proc delete_index(state: var State, i:int) =
  state.route.delete(i)
  state.route_id.delete(i)

# たぶん使っていない
proc setNeighbor(input: Input, state: var State):NeighborInfo =
  result.state = state
  when DEBUG:
    let start_dist = getDistance(state.route)
  var a = getIndexTable(state)
  let
    i = a.keys.toSeq.sample
    (srci, dsti) = a[i]
  #stderr.write "i = ", i, "\n"
  # dstiを削除
  let point_to_move = state.route[dsti]
  state.delete_index(dsti)
  when DEBUG:
    let old_dist = getDistance(state.route)
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
  dsti2 = rand(srci + 1 ..< state.route.len)
  state.route.insert(point_to_move, dsti2)
  state.route_id.insert((1, i), dsti2)
  when DEBUG:
    let new_dist = getDistance(state.route)
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

proc setNeighbor2(input: Input, state: var State):NeighborInfo =
  result.state = state
  var
    a = getIndexTable(state)
  # ランダムに選ぶ
  var del_i:int
  if rand(0 .. 2) > 0:
    del_i = a.keys.toSeq.sample
  else:
    #注文iの選び方をそれを除くと最も改善するものに変更
    del_i = -1
    var
      max_diff = -INF
    for i in a.keys:
      let (srci, dsti) = a[i]
      var diff = 0
      if src_i + 1 == dst_i:
        diff = dist(state.route[src_i - 1], state.route[src_i]) + dist(state.route[src_i], state.route[src_i + 1]) + dist(state.route[dst_i], state.route[dst_i + 1]) - dist(state.route[src_i - 1], state.route[dst_i + 1])
      else:
        diff += dist(state.route[src_i - 1], state.route[src_i]) + dist(state.route[src_i], state.route[src_i + 1]) - dist(state.route[src_i - 1], state.route[src_i + 1])
        diff += dist(state.route[dst_i - 1], state.route[dst_i]) + dist(state.route[dst_i], state.route[dst_i + 1]) - dist(state.route[dst_i - 1], state.route[dst_i + 1])
      if diff > max_diff:
        max_diff = diff
        del_i = i
  let (srci, dsti) = a[del_i]
  # 注文del_iを削除
  doAssert srci < dsti
  state.delete_index(dsti)
  state.delete_index(srci)
  state.orders.delete(state.orders.find(del_i))
  var add_i: int
  if false and rand(0 .. 100) == 0:
    add_i = del_i
  else:
    while true:
      add_i = rand(0 ..< input.order_count)
      if add_i notin state.orders:
        break
  state.orders.add(add_i)
  var
    min_src_i:int
    min_src_diff = INF
    #v = newSeq[tuple[d, si, di: int]]()
    v: tuple[d, si, di: int]
    src_p = input.restaurants[add_i]
    dst_p = input.destinations[add_i]
  v.d = INF
  # 注文add_iを挿入
  for i in 1 ..< state.route.len:
    # i - 1, iの間に入れる
    # ダイレクト
    let dist_old = dist(state.route[i - 1], state.route[i])
    block:
      let d = dist(state.route[i - 1], src_p) + dist(src_p, dst_p) + dist(dst_p, state.route[i]) - dist_old
      if v.d > d:
        v = (d, i, i)
      #v.add (d, i, i)
    if i > 1:
      let d = min_src_diff + dist(state.route[i - 1], dst_p) + dist(dst_p, state.route[i]) - dist_old
      if v.d > d:
        v = (d, min_src_i, i)
      #v.add (d, min_src_i, i)
    let d = dist(state.route[i - 1], src_p) + dist(src_p, state.route[i]) - dist_old
    if d < min_src_diff:
      min_src_diff = d
      min_src_i = i
  #v.sort
  block:
    let (d, src_i, dst_i) = v
    # dst_iを挿入
    state.route.insert(dst_p, dst_i)
    state.route_id.insert((1, add_i), dst_i)
    state.route.insert(src_p, src_i)
    state.route_id.insert((0, add_i), src_i)

  discard

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
  var current_dist = getDistance(state.route)

  # 乱数生成器のシード値を設定
  # 乱数のシード値は固定のものにしておくと、デバッグがしやすくなります
  randomize(41)

  # 山登り法の開始時刻を取得
  let start_time = epochTime()

  # 制限時間(1.9秒)
  # 2秒ちょうどまでやるとTLEになるので、1.9秒程度にしておくとよい
  const time_limit = 1.97
  #const time_limit = 10.0

  # 開始温度と終了温度
  const start_temperature = 2e2
  const end_temperature = 1e0

  # 現在の温度
  var current_temperature = start_temperature

  # 試行回数
  var iteration = 0

  # 山登り法の本体
  while true:
    # 現在時刻を取得
    let current_time = epochTime()

    # 制限時間になったら終了
    if current_time - start_time >= time_limit:
      break
    
    # 訪問先が配達先であるようなインデックスの中から、
    # 「i番目の訪問先をj番目に移動」する操作をランダムに選ぶことで、
    # ある配達先を訪れる順序を他の配達先の間に変える
    # 貪欲法で求めた解では、配達先の訪問順序は0-indexedで51番目～100番目であることに注意
    # (AtCoderオフィス、レストラン50軒、配達先50軒、AtCoderオフィスの順に並んでいる)

    #var neighbor_info = setNeighbor(input, state)
    var
      old_state = state
      neighbor_info = setNeighbor2(input, state)

    # 操作後の経路の距離を計算
    let new_dist = getDistance(state.route)

    # 【穴埋め】操作後の距離が操作前以下なら採用する
    # 【穴埋め】操作前より悪化していても、確率で採用する(悪化度合いが小さく、温度が高いほど採用されやすい)
    # 【ヒント】採用確率(0.0以上1.0未満)は exp(float64(current_dist - new_dist) / current_temperature) で計算できる
    # 【ヒント】rand(1.0) と書くと、0.0以上1.0以下の乱数が得られる
    ## put your code here ##
    if new_dist <= current_dist or rand(1.0) < exp(float(current_dist - new_dist) / current_temperature):
      current_dist = new_dist
    else:
      # 採用されなかったら元に戻す
      state = old_state.move()

    # 試行回数のカウントを増やす
    # 進行状況を可視化するため、一定回数ごとに現在の試行回数と合計距離を標準エラー出力に出力
    iteration += 1
    if iteration mod 100000 == 0:
      stderr.writeLine "iteration: ", iteration, ", total distance: ", current_dist
    
    # 現在の経過時間の割合を計算する
    let progress = (current_time - start_time) / time_limit
    # 【穴埋め】温度の更新
    # 【ヒント】現在の経過時間の割合に対する温度は pow(start_temperature, 1.0 - progress) * pow(end_temperature, progress) で計算できる
    ## put your code here ##
    current_temperature = pow(start_temperature, 1.0 - progress) * pow(end_temperature, progress)

    # ここまで穴埋めして実行できるようになったら、
    # 開始温度(start_temperature)と終了温度(end_temperature)を変えてみて、実行結果がどう変わるかを確認してみましょう

  # 試行回数と合計距離を標準エラー出力に出力
  stderr.writeLine "--- Result ---"
  stderr.writeLine "iteration   : ", iteration
  stderr.writeLine "total distance: ", current_dist

  return newOutput(state)

proc main() =
  # 入力データを読み込む
  var input = readInput()

  # 問題を解く
  # for x in countup(300, 500, 100):
  #   for y in countup(300, 500, 100):
  #     stderr.writeLine x, " ", y
  #     var output_greedy = solveGreedy(input, newPoint(x, y))
  var output_greedy = solveGreedy(input, newPoint(500, 500))
  var output = solveSimulatedAnnealing(input, output_greedy)

  # 解を出力する
  print(output)

when isMainModule:
  main()
