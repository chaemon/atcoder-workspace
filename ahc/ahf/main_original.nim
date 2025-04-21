## @file a03_simulated_annealing.nim
## @brief
## 今いる点から最も近いレストランに行くことを50回繰り返し、その後今いる点から最も近い目的地に行くことを50回繰り返す解法プログラム

import math, random, strutils, sequtils, times
import algorithm
import atcoder/header

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

## @brief 出力データを表す型
type Output = ref object
  ## @brief 移動距離の合計
  dist_sum: int
  ## @brief 選択した注文のリスト
  orders: seq[int]
  ## @brief 配達ルート
  route: seq[Point]

## @brief 出力データを構築する
## @param orders 選択した注文のリスト
## @param route 配達ルート
proc newOutput(orders: seq[int], route: seq[Point]): Output =
  var output = Output()

  output.orders = orders
  output.route = route

  output.dist_sum = 0
  for i in 0 ..< route.high:
    output.dist_sum += dist(route[i], route[i + 1])

  return output

## @brief 解を出力する
proc print(output: Output) =
  # 選択した注文の集合を出力する
  stdout.write output.orders.len

  for i in 0 ..< output.orders.len:
    # 0-indexed -> 1-indexedに変更
    stdout.write " ", output.orders[i] + 1

  stdout.writeLine ""

  # 配達ルートを出力する
  stdout.write output.route.len

  for i in 0 ..< output.route.len:
    stdout.write " ", output.route[i].x, " ", output.route[i].y

  stdout.writeLine ""

## @brief 問題を解く関数（この関数を実装していきます）
## @param input 入力データ
## @return 出力データ
proc solveGreedy(input: Input): Output =
  # 貪欲その2
  # 以下を順に実行するプログラム
  # 1.オフィスから距離office_dist以下の注文だけを候補にする
  # 2.高橋君は最初オフィスから出発する
  # 3.訪問したレストランが50軒に達するまで、今いる場所から一番近いレストランに移動することを繰り返す
  # 4.受けた注文を捌ききるまで、今いる場所から一番近い配達先に移動することを繰り返す
  # 5.オフィスに帰る

  var candidates = newSeq[int]()
  var orders = newSeq[int]()
  var route = newSeq[Point]()


  # 1.オフィスから距離400以下の注文だけを候補にする
  #let office_dist = 300
  #for i in 0 ..< input.order_count:
  #  if input.office.dist(input.restaurants[i]) <= office_dist and input.office.dist(input.destinations[i]) <= office_dist:
  #    candidates.add(i)
  var cv: seq[tuple[d, i:int]]
  for i in 0 ..< input.order_count:
    let
      d1 = input.office.dist(input.restaurants[i])
      d2 = input.office.dist(input.destinations[i])
    cv.add (max(d1, d2), i)
  cv.sort()
  
  for i in 0 ..< 87:
    candidates.add cv[i].i


  # 2.オフィスからスタート
  route.add(input.office)
  var current_position = input.office # 現在地
  var total_dist = 0          # 総移動距離

  # 3.訪問したレストランが50軒に達するまで、今いる場所から一番近いレストランに移動することを繰り返す

  # 同じレストランを2回訪れてはいけないので、訪問済みのレストランを記録する
  var visited_restaurant = newSeqWith(input.order_count, false)

  # pickup_count(=50)回ループ
  for i in 0 ..< input.pickup_count:
    # レストランを全探索して、最も近いレストランを探す
    var nearest_restaurant = 0  # レストランの番号
    var min_dist = 1000000    # 最も近いレストランの距離

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

    # 訪問済みレストランの配列にtrueをセット
    visited_restaurant[nearest_restaurant] = true

    # 総移動距離の更新
    total_dist += min_dist

    # デバッグしやすいよう、標準エラー出力にレストランを出力
    # 標準エラー出力はデバッグに有効なので、AHCでは積極的に活用していきましょう
    let restaurant_pos = input.restaurants[nearest_restaurant]
    stderr.writeLine i, "番目のレストラン: p_", nearest_restaurant, " = (", restaurant_pos.x, ", ", restaurant_pos.y, ")"

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
    var min_dist = 1000000                 # 最も近い配達先の距離

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

    # 配達先のリストから削除
    destinations.del(nearest_index)

    # 総移動距離の更新
    total_dist += min_dist

    # デバッグしやすいよう、標準エラー出力に配達先を出力
    let destination_pos = input.destinations[nearest_destination]
    stderr.writeLine i, "番目の配達先: q_", nearest_destination, " = (", destination_pos.x, ", ", destination_pos.y, ")"

  # 5.オフィスに戻る
  route.add(input.office)
  total_dist += current_position.dist(input.office)

  # 合計距離を標準エラー出力に出力
  # 標準エラー出力はデバッグに有効なので、AHCでは積極的に活用していきましょう
  stderr.writeLine "total distance: ", total_dist

  return newOutput(orders, route)

## @brief 経路の距離を計算する
## @param route 経路
## @return 経路の距離
proc getDistance(route: seq[Point]): int =
  var dist = 0
  for i in 0 ..< route.high:
    dist += route[i].dist(route[i + 1])
  return dist

type NeighborInfo = object
  i, j:int
  point_to_move:Point

proc setNeighbor(input: Input, route: var seq[Point]):NeighborInfo =
  # 訪問先が配達先であるようなインデックスの中から i, j をランダムに選ぶ
  let i = rand(input.pickup_count - 1) + input.pickup_count + 1
  let j = rand(input.pickup_count - 1) + input.pickup_count + 1

  # i番目の訪問先をj番目に移動する操作を行う
  let point_to_move = route[i]
  route.delete(i)
  route.insert(point_to_move, j)
  return NeighborInfo(i:i, j:j, point_to_move:point_to_move)

proc resetNeighbor(input: Input, route: var seq[Point], ninfo: NeighborInfo) =
  route.delete(ninfo.j)
  route.insert(ninfo.point_to_move, ninfo.i)


## @brief 配達先の訪問順序を焼きなまし法で改善する関数（この関数を実装していきます）
## @param input 入力データ
## @param output_greedy 貪欲法で求めた出力データ
## @return 出力データ
proc solveSimulatedAnnealing(input: Input, output_greedy: Output): Output =
  # 焼きなまし法
  # 「ある1つの配達先を訪問する順序を、別の場所に入れ替える」操作を繰り返すことで、経路を改善する

  # 貪欲法で求めた解をコピー(これを初期解とする)
  var orders = output_greedy.orders
  var route = output_greedy.route

  # 現在の経路の距離を計算
  var current_dist = getDistance(route)

  # 乱数生成器のシード値を設定
  # 乱数のシード値は固定のものにしておくと、デバッグがしやすくなります
  randomize(42)

  # 山登り法の開始時刻を取得
  let start_time = epochTime()

  # 制限時間(1.9秒)
  # 2秒ちょうどまでやるとTLEになるので、1.9秒程度にしておくとよい
  const time_limit = 1.95

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

    var neighbor_info = setNeighbor(input, route)

    # 操作後の経路の距離を計算
    let new_dist = getDistance(route)

    # 【穴埋め】操作後の距離が操作前以下なら採用する
    # 【穴埋め】操作前より悪化していても、確率で採用する(悪化度合いが小さく、温度が高いほど採用されやすい)
    # 【ヒント】採用確率(0.0以上1.0未満)は exp(float64(current_dist - new_dist) / current_temperature) で計算できる
    # 【ヒント】rand(1.0) と書くと、0.0以上1.0以下の乱数が得られる
    ## put your code here ##
    if new_dist <= current_dist or rand(1.0) < exp(float(current_dist - new_dist) / current_temperature):
      current_dist = new_dist
    else:
      # 採用されなかったら元に戻す
      resetNeighbor(input, route, neighborinfo)



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

  return newOutput(orders, route)

proc main() =
  # 入力データを読み込む
  var input = readInput()

  # 問題を解く
  var output_greedy = solveGreedy(input)
  var output = solveSimulatedAnnealing(input, output_greedy)

  # 解を出力する
  print(output)

when isMainModule:
  main()
