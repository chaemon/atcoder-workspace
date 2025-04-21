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
    route_id.push((2,1001));
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
    route_id.push((2,1001));

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

    let mut rand = Pcg64Mcg::new(42);

    // 乱数生成器を用意
    // 乱数のシード値は固定のものにしておくと、デバッグがしやすくなりま

    // 焼きなまし法の開始時刻を取得
    let start_time = Instant::now();

    // 制限時間(1.9秒)
    // 2秒ちょうどまでやるとTLEになるので、1.9秒程度にしておくとよい
    let time_limit = Duration::from_millis(1990);

    // 開始温度と終了温度
    let start_temperature: f64 = 2e2;
    let end_temperature: f64 = 1e0;

    // 現在の温度
    let mut current_temperature = start_temperature;

    // 試行回数
    let mut iteration = 0;

    let mut route_id = route_id.clone();
    let mut order_states = vec![(1001,1001);1000];
    for i in 0..route_id.len(){
        //オフィスの部分は除く
        if route_id[i].0 == 2{
            continue;
        }
        let (place_type,used_order) = route_id[i];
        //レストランは目的地の先に来るので，レストランより先に目的地が更新されることはありえない
        if place_type == 0{
            order_states[used_order].0 = i;
        }
        else{
            order_states[used_order].1 = i;
        }
    }
    // 焼きなまし法の本体
    loop {
        // 現在時刻を取得
        let elapsed = start_time.elapsed();

        // 制限時間になったら終了
        if elapsed >= time_limit {
            break;
        }
        
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

        let (del_v,add_v,new_route,new_orders) = restaurant_change(&input,&route,&orders,&order_states,&mut rand);
        let new_dist = get_distance(&new_route);
        let p = ((current_dist - new_dist) as f64 / current_temperature).exp().min(1.0);
        if rand.gen_bool(p){
            //del_v,add_vを利用してroute_idなどを更新
            route = new_route;
            orders = new_orders;
            let (del_i,srci,dsti) = del_v;
            route_id.remove(dsti);
            route_id.remove(srci);
            order_states[del_i] = (1001,1001);
            let (add_i,srci,dsti) = add_v;
            route_id.insert(dsti,(1,add_i));
            route_id.insert(srci,(0,add_i));
            assert!(order_states[add_i] == (1001,1001));
            for i in 0..route_id.len(){
                //オフィスの部分は除く
                if route_id[i].0 == 2{
                    continue;
                }
                let (place_type,used_order) = route_id[i];
                //レストランは目的地の先に来るので，レストランより先に目的地が更新されることはありえない
                if place_type == 0{
                    order_states[used_order].0 = i;
                }
                else{
                    order_states[used_order].1 = i;
                }
            }
            current_dist = new_dist;
        }
        // ここまで穴埋めして実行できるようになったら，
        // 開始温度(start_temperature)と終了温度(end_temperature)を変えてみて、実行結果がどう変わるかを確認してみましょう
    }

    // 試行回数と合計距離を標準エラー出力に出力
    eprintln!("--- Result ---");
    eprintln!("iteration     : {}", iteration);
    eprintln!("total distance: {}", current_dist);
    eprintln!("{:?}",route_id);

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
fn restaurant_change(input: &Input,route: &Vec<Point>,orders:&Vec<usize>,order_states:&Vec<(usize,usize)>,rand: &mut Pcg64Mcg)->((usize,usize,usize),(usize,usize,usize),Vec<Point>,Vec<usize>){
    let mut route = route.clone();
    let mut orders = orders.clone();
    //route_id[i] := i番目の移動先がどの注文に対応しているのか　同じ要素が二つづつ存在するが，先に来る方が絶対にレストラン 0番目と101番目はオフィス
    //order_states[i] := i番目の注文は何番目に配達されるのか (レストランの配達タイミング，目的地への配達タイミング) (1001,1001)なる注文は使用していない

    /* 注文を入れ替え，それに伴う最適位置を走査する
    削除する注文は，削除することで距離が最も短くなるもの（一番足を引っ張っている注文）とする
    */
    
    let mut del_order = 0;
    //局所最適を防ぐため，一定確率で完全ランダムに選定を行う
    if rand.gen_bool(0.3){
        del_order = rand.gen_range(0..orders.len());
        del_order = orders[del_order];
    }
    else{
        let mut max_diff = -1000000;
        for &order in orders.iter(){
            let (srci,dsti) = order_states[order];
            //i番目の注文を削除することでどれだけ得をするか，距離の差分を計算
            let diff = {
                // (srci-1) -- (srci) -- (dsti) -- (dsti+1)
                // =>(srci-1) - (dsti+1)
                let pre_srcp =route[srci-1];
                let srcp = route[srci];
                let aft_srcp = route[srci+1];
                let pre_dstp = route[dsti-1];
                let dstp = route[dsti];
                let aft_dstp = route[dsti+1];
                if srci + 1 == dsti{
                    pre_srcp.dist(srcp) + srcp.dist(dstp) + dstp.dist(aft_dstp)
                    - pre_srcp.dist(aft_dstp)
                }
                // (srci-1) -- (srci)......--(dsti-1)--(dsti)--(dsti+1)
                // => (srci-1)--(srci+1).....--(dsti-1)--(dsti+1)
                else{
                    (pre_srcp.dist(srcp) + srcp.dist(aft_srcp)- pre_srcp.dist(aft_srcp))
                    +(pre_dstp.dist(dstp) + dstp.dist(aft_dstp)- pre_dstp.dist(aft_dstp))
                }
            };
            if max_diff < diff{
                max_diff = diff;
                del_order = order;
            }
        }
    }
    //配達ルートから削除
    let (srci,dsti) = order_states[del_order];
    route.remove(dsti);
    route.remove(srci);
    orders.remove(orders.iter().position(|x| x == &del_order).unwrap());
    let del_v = (del_order,srci,dsti);
    let add_i = {
        let mut id = rand.gen_range(0..input.order_count);
        loop{
            if !orders.contains(&id){
                break;
            }
            id = rand.gen_range(0..input.order_count);
        }
        id
    };
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
    let add_v = (add_i,srci,dsti);
    //削除した注文，追加した注文，更新後のルート
    (del_v,add_v,route,orders)
    
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


