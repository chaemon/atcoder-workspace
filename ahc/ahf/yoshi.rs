//! 03_simulated_annealing_answer.rs
//! 貪欲法で初期解を求めた後、配達先の訪問順序を焼きなまし法で改善する解法プログラム
//! 必要なクレートの導入には cargo add proconio@=0.4.5 rand@=0.8.5 rand_pcg@=0.3.1 を実行してください
use proconio::input;
use rand::{seq::IteratorRandom, Rng, SeedableRng};
use rand_pcg::Pcg64Mcg;
use std::{
    fmt::Display,
    time::{Duration, Instant},
};
use std::collections::*;
/// 2次元座標上の点を表す構造体
#[derive(Debug, Clone, Copy)]
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    /// コンストラクタ
    fn new(x: i32, y: i32) -> Self {
        Self { x, y }
    }

    /// 2点間のマンハッタン距離を計算する
    fn dist(&self, other: Point) -> i32 {
        (self.x - other.x).abs() + (self.y - other.y).abs()
    }
}

impl Display for Point {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{} {}", self.x, self.y)
    }
}

/// 入力データを表す構造体
struct Input {
    /// レストランの数 (=1000)
    order_count: usize,
    /// 選択する必要のある注文の数 (=50)
    pickup_count: usize,
    /// AtCoderオフィスの座標 (=(400, 400))
    office: Point,
    /// レストランの座標の配列
    restaurants: Vec<Point>,
    /// 目的地の座標の配列
    destinations: Vec<Point>,
}

impl Input {
    /// 入力データを読み込む
    fn read() -> Self {
        let order_count = 1000;
        let pickup_count = 50;
        let office = Point::new(400, 400);

        let mut restaurants = vec![];
        let mut destinations = vec![];

        for _ in 0..order_count {
            input! {
                a: i32,
                b: i32,
                c: i32,
                d: i32,
            }

            restaurants.push(Point::new(a, b));
            destinations.push(Point::new(c, d));
        }

        Self {
            order_count,
            pickup_count,
            office,
            restaurants,
            destinations,
        }
    }
}

/// 出力データを表す構造体
struct Output {
    /// 移動距離の合計
    dist_sum: i32,
    /// 選択した注文のリスト
    orders: Vec<usize>,
    /// 配達ルート
    route: Vec<Point>,
}

impl Output {
    /// コンストラクタ
    fn new(orders: Vec<usize>, route: Vec<Point>) -> Self {
        let mut dist_sum = 0;

        for i in 0..route.len() - 1 {
            dist_sum += route[i].dist(route[i + 1]);
        }
        Self {
            dist_sum,
            orders,
            route,
        }
    }

    /// 解を出力する
    fn print(&self) {
        // 選択した注文の集合を出力する
        print!("{}", self.orders.len());

        for &i in &self.orders {
            // 0-indexed -> 1-indexedに変更
            print!(" {}", i + 1);
        }

        println!();

        // 配達ルートを出力する
        print!("{}", self.route.len());

        for p in &self.route {
            print!(" {}", p);
        }

        println!();
    }
}

/// route の総移動距離を計算
fn get_distance(route: &Vec<Point>) -> i32 {
    let mut dist = 0;

    for i in 0..route.len() - 1 {
        dist += route[i].dist(route[i + 1]);
    }

    dist
}

/// 問題を解く関数（この関数を実装していきます）
fn solve_greedy(input: &Input) -> (Output,Vec<(usize,usize)>) {
    // 貪欲その2
    // 以下を順に実行するプログラム
    // 1.オフィスから距離400以下の注文だけを候補にする
    // 2.高橋君は最初オフィスから出発する
    // 3.訪問したレストランが50軒に達するまで、今いる場所から一番近いレストランに移動することを繰り返す
    // 4.受けた注文を捌ききるまで、今いる場所から一番近い配達先に移動することを繰り返す
    // 5.オフィスに帰る

    let mut candidates = vec![]; // 注文の候補
    let mut orders = vec![]; // 注文の集合
    let mut route = vec![]; // 配達ルート

    let mut cv = vec![];
    for i in 0..input.order_count{
        let d1 = input.office.dist(input.restaurants[i]);
        let d2 = input.office.dist(input.restaurants[i]);
        cv.push((std::cmp::max(d1,d2),i));
    }
    cv.sort();
    for i in 0..83{
        candidates.push(cv[i].1);
    }

    // 2.オフィスからスタート
    route.push(input.office);
    let mut route_id = vec![];
    route_id.push((2,300));
    let mut current_position = input.office; // 現在地
    let mut total_dist = 0; // 総移動距離

    let mut visited_restaurants = vec![false;input.order_count];
    for _ in 0..input.pickup_count{
        let mut nearest_restaurant = 0;
        let mut min_dist  = 1000000;
        for &j in candidates.iter(){
            if visited_restaurants[j]
            {
                continue
            }
            let distance = current_position.dist(input.restaurants[j]);
            if distance < min_dist{
                min_dist = distance;
                nearest_restaurant = j;
            }

        }
        current_position = input.restaurants[nearest_restaurant];
        orders.push(nearest_restaurant);
        route.push(current_position);
        route_id.push((0,nearest_restaurant));
        total_dist += min_dist;
        visited_restaurants[nearest_restaurant] = true;
    }
    // 4.受けた注文を捌ききるまで、今いる場所から一番近い配達先に移動することを繰り返す

    // 行かなければいけない配達先のリスト
    // ordersは最終的に出力しなければならないので、ここでコピーを作成しておく
    // 配達先を訪問したらこのリストから1つずつ削除していく
    let mut destinations = orders.clone();
    eprintln!("length:{}",route.len());
    // pickup_count(=50)回ループ
    for i in 0..orders.len() {
        // 配達先を全探索して、最も近い配達先を探す
        let mut nearest_index = 0; // 配達先リストのインデックス
        let mut nearest_destination = destinations[nearest_index]; // 配達先の番号
        let mut min_dist = i32::MAX; // 最も近い配達先の距離

        // 0～999まで全探索するのではなく、50個のレストランに対応した配達先を全探索することに注意
        for j in 0..destinations.len() {
            // 最短距離が更新されたら記録
            let distance = current_position.dist(input.destinations[destinations[j]]);

            if distance < min_dist {
                min_dist = distance;
                nearest_index = j;
                nearest_destination = destinations[j];
            }
        }

        // 最も近い配達先(nearest_destination)に移動する
        // 現在位置を最も近い配達先の位置に更新
        current_position = input.destinations[nearest_destination];

        // 配達ルートに現在の位置を追加
        route.push(current_position);
        route_id.push((1,nearest_destination));

        // 配達先のリストから削除
        destinations.remove(nearest_index);

        // 総移動距離の更新
        total_dist += min_dist;

        // デバッグしやすいよう、標準エラー出力に配達先を出力
        let destination_pos = input.destinations[nearest_destination as usize];
        eprintln!(
            "{}番目の配達先: q_{} = ({}, {})",
            i, nearest_destination, destination_pos.x, destination_pos.y
        );
    }

    // 5.オフィスに戻る
    route.push(input.office);
    total_dist += current_position.dist(input.office);
    route_id.push((2,300));

    // 合計距離を標準エラー出力に出力
    eprintln!("total distance: {}", total_dist);

    (Output::new(orders, route),route_id)
}

/// 配達先の訪問順序を焼きなまし法で改善する関数（この関数を実装していきます）
fn solve_simulated_annealing(input: &Input, output_greedy: &Output,route_id:Vec<(usize,usize)>) -> Output {
    // 焼きなまし法
    // 「ある1つの配達先を訪問する順序を、別の場所に入れ替える」操作を繰り返すことで、経路を改善する

    // 貪欲法で求めた解をコピー(これを初期解とする)
    let mut orders = output_greedy.orders.clone();
    let mut route = output_greedy.route.clone();
    // 現在の経路の距離を計算
    let mut current_dist = get_distance(&route);

    // 乱数生成器を用意
    // 乱数のシード値は固定のものにしておくと、デバッグがしやすくなります
    let mut rand = Pcg64Mcg::new(42);

    // 焼きなまし法の開始時刻を取得
    let start_time = Instant::now();

    // 制限時間(1.9秒)
    // 2秒ちょうどまでやるとTLEになるので、1.9秒程度にしておくとよい
    let time_limit = Duration::from_millis(1900);

    // 開始温度と終了温度
    let start_temperature: f64 = 2e2;
    let end_temperature: f64 = 1e0;

    // 現在の温度
    let mut current_temperature = start_temperature;

    // 試行回数
    let mut iteration = 0;

    let mut route_id = route_id.clone();
    // 焼きなまし法の本体
    loop {
        // 現在時刻を取得
        let elapsed = start_time.elapsed();

        // 制限時間になったら終了
        if elapsed >= time_limit {
            break;
        }
        // route_idをもとに，各レストランと目的地がrouteの何番目に位置するかを調べる
        let mut route_numbers = HashMap::new();
        for i in 0..route_id.len(){
            let (place_type,id) = route_id[i];
            if place_type == 2{
                continue;
            }
            if !route_numbers.contains_key(&id){
                route_numbers.insert(id, (1001,1001));
            }
            let data = route_numbers[&id];
            if place_type == 0{
                route_numbers.insert(id, (i,data.1));
            }
            else if place_type == 1{
                route_numbers.insert(id, (data.0,i));
            }
        }
        //削除するレストランを選択する
        let mut del_i = 1;
        let mut max_diff = -1000000;
        for i in route_numbers.keys(){

            //iを削除した場合のdistの差分を計算
            let (srci,dsti) = route_numbers[i];
            let diff = {
                //レストランと目的地が隣接している
                if srci+1 == dsti{
                    route[srci-1].dist(route[srci]) + route[srci].dist(route[srci+1]) + route[dsti].dist(route[dsti+1]) - route[srci-1].dist(route[dsti+1])
                }
                else{
                    (route[srci-1].dist(route[srci]) + route[srci].dist(route[srci+1]) - route[srci-1].dist(route[srci+1]))+
                    (route[dsti-1].dist(route[dsti]) + route[dsti].dist(route[dsti+1]) - route[dsti-1].dist(route[dsti+1]))
                }
            };
            if diff > max_diff{
                max_diff = diff;
                del_i = *i;
            }
        }
        let (srci,dsti) = route_numbers[&del_i];
        route.remove(dsti);
        route.remove(srci);
        orders.remove(orders.iter().position(|&x| x == del_i).unwrap());
        route_id.remove(dsti);
        route_id.remove(srci);

        //新たなレストランを挿入
        let mut add_i = 0;
        loop{
            add_i = rand.gen_range(0..input.order_count);
            if !route_numbers.contains_key(&add_i){
                break;
            }
        }
        orders.push(add_i);
        let mut min_src_i = 0;
        let mut min_src_diff = 1000000;
        let (srcp,dstp) = (input.restaurants[add_i],input.destinations[add_i]);
        let mut v = (1000000,0,0);
        for i in 1..route.len(){
            let dist_old = route[i-1].dist(route[i]);
            let diff = route[i-1].dist(srcp) + srcp.dist(dstp) + dstp.dist(route[i]) - dist_old;
            if v.0 > diff{
                v = (diff,i,i);
            }
            if i > 1{
                let diff = min_src_diff + route[i-1].dist(dstp) + dstp.dist(route[i]) - dist_old;
                if v.0 > diff{
                    v = (diff,min_src_i,i);
                }
            }
            let diff = route[i-1].dist(srcp) + srcp.dist(route[i]) - dist_old;
            if diff < min_src_diff{
                min_src_diff = diff;
                min_src_i = i;
            }

        }
        let (_,srci,dsti) = v;
        route.insert(dsti,dstp);
        route.insert(srci, srcp);
        route_id.insert(dsti,(1,add_i));
        route_id.insert(srci,(0,add_i));
        current_dist = get_distance(&route);
        // 試行回数のカウントを増やす
        // 進行状況を可視化するため、一定回数ごとに現在の試行回数と合計距離を標準エラー出力に出力
        iteration += 1;
        if iteration % 100000 == 0 {
            eprintln!("iteration: {}, total distance: {}", iteration, current_dist);
        }

        // 現在の経過時間の割合を計算する
        let progress = elapsed.as_secs_f64() / time_limit.as_secs_f64();

        // 【穴埋め】温度の更新
        // 【ヒント】現在の経過時間の割合に対する温度は start_temperature.powf(1.0 - progress) * end_temperature.powf(progress) で計算できる
        /* put your code here */
        current_temperature = start_temperature.powf(1.0 - progress) * end_temperature.powf(progress);

        // ここまで穴埋めして実行できるようになったら、
        // 開始温度(start_temperature)と終了温度(end_temperature)を変えてみて、実行結果がどう変わるかを確認してみましょう
    }

    // 試行回数と合計距離を標準エラー出力に出力
    eprintln!("--- Result ---");
    eprintln!("iteration     : {}", iteration);
    eprintln!("total distance: {}", current_dist);

    Output::new(orders, route)
}
fn two_opt(route:&mut  Vec<Point>, i:usize,j:usize) -> Vec<Point>{
    let mut new_route = route[0..i].to_vec();
    let mut reversed = route[i..=j].to_vec();
    reversed.reverse();
    new_route.extend(reversed.iter());
    new_route.extend(route[j+1..].iter());
    new_route
}
fn main() {
    // 入力データを読み込む
    let input = Input::read();

    // 問題を解く
    let (output,route_id) = solve_greedy(&input);
    let output = solve_simulated_annealing(&input, &output,route_id);

    // 出力する
    output.print();
}

