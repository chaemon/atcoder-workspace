const
  DEBUG = true

include atcoder/extra/header/chaemon_header
import random, times, sequtils, math, algorithm
import lib/other/bitutils
import lib/graph/hungarian, lib/graph/graph_template, lib/graph/dijkstra

let start_time = epochTime()

randomize()
let seed = random.rand(0..2^31)
stderr.write("seed: ", seed, "\n")

#randomize(383758548)

let dir:array[4, tuple[dx, dy:int]] = [(0, -1), (-1, 0), (0, 1), (1, 0)]
let dir_str = "LURD"

type Input = object
  N, T:int

type State = object
  a: seq[seq[int]]
  p: tuple[x, y:int]
  score: int

proc counter_direction(d:int):int = d xor 2

const D = 10^8
var cx, cy: int

proc getTree(state:State):seq[tuple[p:int, a:seq[tuple[x, y:int]]]] =
  let N = state.a.len
  var
    vis = Seq[N, N: false]
    group = Seq[(int, int)]
    loop = false
  proc dfs(x, y, p:int):int =
    doAssert state.a[x][y] != 0
    group.add((x, y))
    vis[x][y] = true
    result = 1
    for d, (dx, dy) in dir:
      if p == d or state.a[x][y][d] == 0: continue
      let (x2, y2) = (x + dx, y + dy)
      let d2 = d.counter_direction
      if x2 notin 0 ..< N or y2 notin 0 ..< N or state.a[x2][y2][d2] == 0 : continue
      if vis[x2][y2]:
        loop = true
        continue
      let d = dfs(x2, y2, d2)
      result += d
  var v = Seq[int]
  for x in 0 ..< N:
    for y in 0 ..< N:
      if vis[x][y] or state.a[x][y] == 0: continue
      group.setLen(0)
      let d = dfs(x, y, -1)
      result.add (d, group)
  result.sort(SortOrder.Descending)

proc calcScore(v:seq[(int, seq[(int, int)])]):int =
  var v = v.mapIt(it[1].len)
  result += v[0] * D
  for i in 1 ..< v.len:
    result += v[i] * (100 - v.len - i)

proc calcScore(state:State):int =
  # 最大: D倍
  # その他: 
  (state.getTree).calcScore

proc updateZero(state:var State) =
  found_cnt := 0
  for x in 0..<state.a.len:
    for y in 0..<state.a[0].len:
      if state.a[x][y] == 0:
        state.p = (x, y)
        found_cnt.inc
  doAssert found_cnt == 1

proc updateScore(state:var State) =
  state.score = state.calcScore

proc change[State, Input](state: var State, input: Input, d:int) =
  let
    N = input.N
    (x, y) = state.p
  var
    x2 = x + dir[d].dx
    y2 = y + dir[d].dy
  doAssert x2 in 0..<N and y2 in 0..<N
  doAssert state.a[x][y] == 0
  swap state.a[x][y], state.a[x2][y2]
  state.p = (x2, y2)

#proc neighbor0[State, Input](state:var State, input: Input):auto =
#  let
#    (x, y) = state.p
#    N = input.N
#  candidate := Seq[int]
#  for d, (dx, dy) in dir:
#    let (x2, y2) = (x + dx, y + dy)
#    if x2 notin 0 ..< N or y2 notin 0 ..< N: continue
#    candidate.add d
#  let
#    old_score = state.score
#    d = random.sample(candidate)
#    prev_state = state.prev
#  state.change(input, d)
#  state.score = state.calcScore
#  state.prev = Dir(d:d, prev:prev_state)
#  return (d.counter_direction, old_score)
#
#proc undo0[State, Input](state: var State, input: Input, d:auto) =
#  let (d, old_score) = d
#  state.change(input, d)
#  state.prev = state.prev.prev
#  state.score = old_score

proc neighbor0[State, Input](state:var State, input: Input):auto =
  let N = input.N
  #proc getRandomNoFirst(state:State):(int, int, int, int) =
  #  let t = state.getTree
  #  # (x0, y0)は主要でない木から選ぶ
  #  var x0, y0, x1, y1:int
  #  let M = N^2 - 1 - t[0].a.len
  #  var p = random.rand(0 ..< M)
  #  for i in 1 ..< t.len:
  #    if p < t[i].a.len:
  #      (x0, y0) = t[i].a[p]
  #      break
  #    p -= t[i].a.len
  #    doAssert i < t.len - 1
  #  while true:
  #    x1 = random.rand(0..<N)
  #    y1 = random.rand(0..<N)
  #    if (x0, y0) != (x1, y1) and (x0, y0) != state.p and (x1, y1) != state.p: break
  #  return (x0, y0, x1, y1)

  proc getRandom(state:State):(int, int, int, int) =
    var x0, y0, x1, y1:int
    while true:
      x0 = random.rand(0..<N)
      y0 = random.rand(0..<N)
      x1 = random.rand(0..<N)
      y1 = random.rand(0..<N)
      if (x0, y0) == (x1, y1): continue
      if x0 in cx ..< cx+3 and y0 in cy ..< cy+3 and x1 in cx ..< cx+3 and y1 in cy ..< cy+3:
        break
      if (x0, y0) != state.p and (x1, y1) != state.p: break
    return (x0, y0, x1, y1)

  proc getUnconnected(state: State):(int, int, int, int) =
    proc count_connected(x, y:int):int =
      result = 0
      for d in 4:
        let
          x2 = x + dir[d][0]
          y2 = y + dir[d][1]
        if x2 notin 0..<N or y2 notin 0..<N: continue
        let d2 = d.counter_direction
        if state.a[x2][y2][d2] == 1: result[d] = 1
    var
      c = Seq[N, N: int]
    let (x, y) = block:
      var
        max_val = -int.inf
        v:seq[(int, int)]
      for x in N:
        for y in N:
          if state.a[x][y] == 0: continue
          c[x][y] = count_connected(x, y)
          let k = ((c[x][y] xor state.a[x][y])).popCount
          if max_val < k:
            max_val = k
            v.setLen 0
          if max_val <= k:
            v.add (x, y)
      random.sample(v)
    let (x2, y2) = block:
      var
        min_val = int.inf
        v:seq[(int, int)]
      for x2 in N:
        for y2 in N:
          if state.a[x2][y2] == 0: continue
          let k = ((c[x][y] xor state.a[x2][y2]).popCount + (c[x2][y2] xor state.a[x][y]).popCount)
          if min_val > k:
            min_val = k
            v.setLen 0
          if min_val >= k:
            v.add (x2, y2)
          discard
      v.sample()
    return (x, y, x2, y2)

  var x0, y0, x1, y1: int
  #if random.rand(1.0) < 0.5:
  #  (x0, y0, x1, y1) = state.getRandomNoFirst()
  #else:
  if random.rand(1.0) < 0.3:
    (x0, y0, x1, y1) = state.getRandom()
  else:
    (x0, y0, x1, y1) = state.getUnconnected()
  # var x2, y2, x3, y3:int
  # if (x0, y0) != state.p and (x1, y1) != state.p:
  #   while true:
  #     (x2, y2, x3, y3) = state.getRandom()
  #     if (x2, y2) != state.p and (x3, y3) != state.p:
  #       break
  # else:
  #   x2 = -1
  #   y2 = -1
  #   x3 = -1
  #   y3 = -1
  let old_score = state.score
  if x0 != -1:
    swap state.a[x0][y0], state.a[x1][y1]
  #if x2 != -1:
  #  swap state.a[x2][y2], state.a[x3][y3]
  state.updateZero()
  state.updateScore()
  #state.score = t.calcScore
  return (x0, y0, x1, y1, old_score)
  #return (x0, y0, x1, y1, x2, y2, x3, y3, old_score)

proc undo0[State, Input](state: var State, input: Input, d:auto) =
  #let (x0, y0, x1, y1, x2, y2, x3, y3, old_score) = d
  let (x0, y0, x1, y1, old_score) = d
  #if x2 != -1:
  #  swap state.a[x2][y2], state.a[x3][y3]
  if x0 != -1:
    swap state.a[x0][y0], state.a[x1][y1]
  state.updateZero()
  state.score = old_score

proc solveAnnealing[State, Input](initial_state:State or seq[State], input: Input, T0 = 2000.0, T1 = 600.0, TL = 2.5, end_score = int.inf):auto {.discardable.} =
  var
#    state = State.init(input)
    state = when initial_state isnot seq: @[initial_state] else: initial_state
    T = T0
    best = state[0].score
    best_out = state[0]
    cnt = 0
  for i in 1 ..< state.len:
    let s = state[i].score
    if s > best:
      best = s
      best_out = state[i]
  block Anneling:
    while true:
      cnt.inc
      if (cnt and ((1 shl 8) - 1)) == 0:
        let t = (epochTime() - start_time) / TL
        if t >= 1.0:
          break Anneling
        T = T0.pow(1.0 - t) * T1.pow(t)
      for state in state.mitems:
        let old_score = state.score
        #if rand(1.0) <= 0.5:
        when true:
          let d = state.neighbor0(input)
          if old_score > state.score and rand(1.0) > exp((state.score - old_score).float/T):
            state.undo0(input, d)
        #else:
        #  let d = state.neighbor1(input)
        #  if old_score > state.score and rand(1.0) > exp((state.score - old_score).float/T):
        #    state.undo1(input, d)
        if best < state.score:
          best = state.score
          best_out = state
          if best >= end_score:
            break Anneling
  stderr.write "cnt: ", cnt, "\n"
  stderr.write "time: ", epochTime() - start_time, "\n"
  stderr.write "found: ", input.N^2 - 1 - (best div D), "\n"
  best_out

proc get_direction(d:int):seq[string] =
  result = Seq[3: '.'.repeat(3)]
  if d != 0: result[1][1] = '#'
  else:
    for i in 3:
      for j in 3:
        result[i][j] = ' '
  # 左
  if d[0] == 1:
    result[1][0] = '#'
  # 上
  if d[1] == 1:
    result[0][1] = '#'
  # 右
  if d[2] == 1:
    result[1][2] = '#'
  # 下
  if d[3] == 1:
    result[2][1] = '#'


proc write(state:State) =
  let N = state.a.len
  var ans = Seq[N * 3: ' '.repeat(N * 3)]
  for i in N:
    for j in N:
      var v = get_direction(state.a[i][j])
      for i2 in 3:
        for j2 in 3:
          ans[i * 3 + i2][j * 3 + j2] = v[i2][j2]
  for a in ans:
    echo a

proc calc_inversion(a:seq[int]):int =
  result = 0
  for i in a.len:
    for j in i + 1..<a.len:
      if a[i] > a[j]: result.inc


proc find_9_puzzle(a, dst:seq[int]):seq[int] =
  # 現状はaで
  # [1, 2, 3
  #  4, 5, 6
  #  7, 8, 0]にしたい
  let D = 9 * 8 * 7 * 6 * 5 * 4 * 3 * 2 * 1
  var
    dist = Seq[D: int.inf]
    vis = Seq[D: false]
    di = Seq[D: seq[int]]
    id = initTable[seq[int], int]()
    prev = Seq[D: tuple[i, d:int]]
  block:
    var
      a = (0..<9).toSeq
      i = 0
    while true:
      di[i] = a
      id[a] = i
      if not a.nextPermutation: break
      i.inc
  dist[id[a]] = 0
  var q = initDeque[tuple[src, dst:seq[int], d:int]]()
  q.addLast (newSeq[int](), a, -1)
  while q.len > 0:
    var
      (src, a, d) = q.popFirst
      zi = 0
    let u = id[a]
    if vis[u]: continue
    vis[u] = true
    if d == -1:
      prev[u] = (-1, d)
    else:
      prev[u] = (id[src], d)
    while zi < a.len:
      if a[zi] == 0: break
      zi.inc
    doAssert zi in 0 ..< a.len
    let da = dist[u]
    let
      i = zi div 3
      j = zi mod 3
    var a_prev = a
    for d in dir.len:
      let
        i2 = i + dir[d][0]
        j2 = j + dir[d][1]
      if i2 notin 0 ..< 3 or j2 notin 0 ..< 3: continue
      let zi2 = i2 * 3 + j2
      swap a[zi], a[zi2]
      let u2 = id[a]
      if dist[u2] > da + 1:
        dist[u2] = da + 1
        q.addLast((a_prev, a, d))
      swap a[zi], a[zi2]
  block:
    var i = id[dst]
    while true:
      var (i2, d) = prev[i]
      if d == -1: break
      result.add d
      swap i, i2
    result.reverse

proc find_3_by_3(src, dst:seq[int]):seq[int] =
  #var a = @[
  #  -1, 1, 2,
  #  3, 0, 3,
  #  3, 3, 3]
  #var a2 = @[
  #  -1, 2, 1,
  #   3, 0, 3,
  #   3, 3, 3]
  var
    q = initDeque[tuple[src, dst:seq[int], d:int]]()
    vis = initSet[seq[int]]()
    dist = initTable[seq[int], int]()
    prev = initTable[seq[int], tuple[src:seq[int], d:int]]()
  q.addLast (src:newSeq[int](), dst:src, d: -1)
  dist[src] = 0
  while q.len > 0:
    var
      (s, a, d) = q.popFirst
      zi = 0
    if a in vis: continue
    vis.incl a
    prev[a] = (s, d)
    while zi < a.len:
      if a[zi] == 0: break
      zi.inc
    doAssert zi in 0 ..< a.len
    let da = dist[a]
    let
      i = zi div 3
      j = zi mod 3
    doAssert i in 0..<3 and j in 0..<3
    var
      a_prev = a
    for d in dir.len:
      let
        i2 = i + dir[d][0]
        j2 = j + dir[d][1]
      if i2 notin 0..<3 or j2 notin 0..<3: continue
      if a[i2][j2] == -1: continue
      let zi2 = i2 * 3 + j2
      swap a[zi], a[zi2]
      if a notin dist:
        dist[a] = int.inf
      if dist[a] > da + 1:
        dist[a] = da + 1
        q.addLast (a_prev, a, d)
      swap a[zi], a[zi2]
  block:
    var a2 = dst
    while true:
      var (a, d) = prev[a2]
      if d == -1: break
      result.add d
      swap a, a2
    result.reverse

proc set_zero_pos(state: var State) =
  for x in state.a.len:
    for y in state.a[x].len:
      if state.a[x][y] == 0:
        state.p = (x, y)


proc shuffle(state: var State) =
  let N = state.a.len
  var a = newSeq[int]()
  for i in N:
    a &= state.a[i]
  a.shuffle()
  for i in N:
    state.a[i] = a[i * N ..< (i + 1) * N]
  state.set_zero_pos()

proc main() =
  let
    N, T = nextInt()
    a = Seq[N: nextString()]
  cx = N div 2 - 1
  if N mod 2 == 0:
    cy = cx - 1
  else:
    cy = cx
  let zp = (N div 2, N div 2)
  #let zp = (N - 1, N - 1)
  var
    state = State(a:Seq[N, N: 0])
    input = Input(N:N, T:T)
  for i in N:
    for j in N:
      state.a[i][j] = 
        if a[i][j] in '0'..'9': a[i][j].ord - '0'.ord
        else: a[i][j].ord - 'a'.ord + 10
  state.set_zero_pos()
  var
    state_ans: State
    state_v: seq[State]
  for i in 5:
    var state = state
    state.shuffle
    if state.p != zp:
      swap state.a[state.p[0]][state.p[1]], state.a[zp[0]][zp[1]]
      state.p = zp
    state.score = state.calcScore
    state_v.add state
  state_ans = solveAnnealing(state_v, input, TL = 2.1, end_score = (N^2 - 1) * D)
  #state_ans.write
  proc id(i, j:int):int =
    doAssert i in 0..<N and j in 0..<N
    i * N + j
  proc calc_cost(x, y, x2, y2:int):int =
    let
      dx = abs(x - x2)
      dy = abs(y - y2)
      m = min(dx, dy)
      M = max(dx, dy)
    #return (M - m) * 5 + m * 3 + m * 3 + M + m
    return M * 6 + m * 2
  proc id_rev(n:int):(int, int) =
    doAssert n in 0..<N^2
    (n div N, n mod N)
  var dst, dst_inv = Seq[N^2: int]
  proc set_dst(first = false) =
    var A = Seq[N^2, N^2: 10^11]
    var zero_dist:int
    for i in N:
      for j in N:
        let p = id(i, j)
        for i2 in N:
          for j2 in N:
            # (i, j)を(i2, j2)に持っていくコストを記述
            let p2 = id(i2, j2)
            if state.a[i][j] != state_ans.a[i2][j2]: continue
            if state.a[i][j] == 0:
              zero_dist = abs(i - i2) + abs(j - j2)
              A[p][p2] = 0
            else:
              A[p][p2] = calc_cost(i, j, i2, j2)
    var (m, dst_tmp) = A.hungarian
    dst = dst_tmp
    block check:
      var s = 0
      for i in A.len:
        s += A[i][dst[i]]
      doAssert m == s
    if first:
      proc change_dst(dst:var seq[int]) =
        var type_to_pos = Seq[16: seq[(int, int)]]
        for i in N:
          for j in N:
            if state.a[i][j] == 0: continue
            type_to_pos[state.a[i][j]].add (i, j)
        debug "CHANGE!!"
        var
          max_val = -int.inf
          max_index = -1
        for i in 1 ..< type_to_pos.len:
          if max_val < type_to_pos[i].len:
            max_val = type_to_pos[i].len
            max_index = i
        doAssert max_val >= 2
        let
          p = type_to_pos[max_index][^1]
          q = type_to_pos[max_index][^2]
          i = id(p[0], p[1])
          j = id(q[0], q[1])
        swap(dst[i], dst[j])
        discard
      if calc_inversion(dst) mod 2 != zero_dist mod 2:
        dst.change_dst()
        doAssert calc_inversion(dst) mod 2 == zero_dist mod 2
    # dstの順列を見る
    for i in dst.len:
      dst_inv[dst[i]] = i

  set_dst(true)

  var initial_cost = Seq[N * N: int]
  for i in N:
    for j in N:
      let p2 = dst[id(i, j)]
      let (i2, j2) = id_rev(p2)
      initial_cost[id(i2, j2)] = calc_cost(i, j, i2, j2)

  proc write_dst() =
    for i in 0..<N:
      echo dst[i * N ..< (i + 1) * N]
    echo ""

  var move_log = Seq[int]
  block:
    var (x, y) = state.p

    proc make_move(d:int) =
      # dstとdst_inv, x, yだけを変更
      # (i, j)に行き先がdst[id(i, j)]のものを配置する
      var
        p = id(x, y)
        x2 = x + dir[d][0]
        y2 = y + dir[d][1]
        p2 = id(x2, y2)
#      debug "move: ", x, y, x2, y2
      doAssert x2 in 0 ..< N and y2 in 0 ..< N
      swap state.a[x][y], state.a[x2][y2]
      move_log.add d
      # (x, y)と(x2, y2)が入れ替わる
      swap dst[p], dst[p2]
      dst_inv[dst[p]] = p
      dst_inv[dst[p2]] = p2
      x = x2
      y = y2
      discard
    var wall = Seq[N: '.'.repeat(N)]
    proc calc_dist(a, b:(int, int)):int = abs(a[0] - b[0]) + abs(a[1] - b[1])
    type P = tuple[z, t: (int, int)]
    proc get_route(src, dst: P):seq[int] =
      proc isValid(x:(int, int)):bool =
        x[0] in 0..<N and x[1] in 0..<N and wall[x[0]][x[1]] == '.'
      # (i, j)から(i2, j2)のルートを検索
      # ただし、wall[i][j]が#なところは通らない
      var
        dist = initTable[P, int]()
        vis = initSet[P]()
        prev = initTable[P, tuple[src:P, d:int]]() # (x, y)からdで戻る
      dist[src] = 0
      var q = initDeque[tuple[src, dst:P, d:int]]()
      q.addLast (((-1, -1), (-1, -1)), src, -1)
      while q.len > 0:
        var (src, dst, d) = q.popFirst
        if dst in vis: continue
        vis.incl dst
        prev[dst] = (src, d)
        let da = dist[dst]
        var dist_zt = calc_dist(dst.z, dst.t)
        doAssert dist_zt > 0
        if dist_zt >= 2: # 距離が2以上のときは距離を縮める動きしか認められない
          for d in dir.len:
            let z2 = (dst.z[0] + dir[d][0], dst.z[1] + dir[d][1])
            if not z2.isValid: continue
            if calc_dist(z2, dst.t) >= dist_zt: continue
            if (z2, dst.t) notin dist: dist[(z2, dst.t)] = int.inf
            if dist[(z2, dst.t)] > da + 1:
              dist[(z2, dst.t)] = da + 1
              q.addLast((dst, (z2, dst.t), d))
        else:
          for d in dir.len:
            let z2 = (dst.z[0] + dir[d][0], dst.z[1] + dir[d][1])
            if not z2.isValid: continue
            var t2 = dst.t
            if z2 == t2:
              t2 = dst.z
            if (z2, t2) notin dist: dist[(z2, t2)] = int.inf
            if dist[(z2, t2)] > da + 1:
              dist[(z2, t2)] = da + 1
              q.addLast((dst, (z2, t2), d))
      var p = dst
      doAssert p in prev
      result = newSeq[int]()
      while true:
        let (src, d) = prev[p]
        if d == -1: break
        result.add d
        p = src
      result.reverse
    var
      initial_sum = 0
      actual_sum = 0
    proc move_block(i, j, zi, zj: int, i2 = -1, j2 = -1) =
      # マス(i, j)に(i2, j2)に置くべきものを置く
      # (zi, zj)は空マスを動かしたい位置
      var
        i2 = i2
        j2 = j2
      # (i, j)に(i2, j2)のパネルを移動させる
      if i2 == -1:
        var p2 = dst_inv[id(i, j)]
        (i2, j2) = id_rev(p2)
        doAssert dst[id(i2, j2)] == id(i, j)
      #if (i, j) == (i2, j2): return
      # 空きますを(i2, j2)の隣に持ってくる
      initial_sum += initial_cost[id(i, j)]
      actual_sum += calc_cost(i, j, i2, j2)
      #debug i, j, i2, j2, calc_cost(i, j, i2, j2), initial_cost[id(i, j)]
      doAssert wall[i2][j2] == '.'
      var r = get_route(((x, y), (i2, j2)), ((zi, zj), (i, j)))
      for d in r:
        make_move(d)
#      doAssert dst[id(i, j)] == id(i, j)
      # 空きますとのペアで調べる
      discard
    
    proc move_block_row(p:(int, int), d, n:int):(int, int) =
      var
        (x, y) = p
        d2 = (d + 1) mod 4
      for i in n - 2:
        let (zx, zy) = (x + dir[d2].dx, y + dir[d2].dy)
        move_block(x, y, zx, zy)
        wall[x][y] = '#'
        x += dir[d][0]
        y += dir[d][1]
      # x0
      # x   x1
      # x2
      var
        (x1, y1) = (x + dir[d2].dx, y + dir[d2].dy)
        (zx, zy) = (x1, y1)
        (x2, y2) = (x + dir[d].dx, y + dir[d].dy)
        (x0, y0) = (x - dir[d].dx, y - dir[d].dy)
        p2 = dst_inv[id(x2, y2)]
        (i2, j2) = id_rev(p2) # (x2, y2)にもっていきたいものの今ある場所→これを(x, y)にもってく
      move_block(x, y, zx, zy, i2, j2)
      zx -= dir[d].dx; zy -= dir[d].dy
      wall[x][y] = '#'

      proc id_local(x, y:int):int = x * 3 + y
      let
        bx = min([x0, x0 + dir[d].dx * 2, x0 + dir[d2].dx * 2])
        by = min([y0, y0 + dir[d].dy * 2, y0 + dir[d2].dy * 2])
      # (x0, y0)からd方向とd2方向に3つずつ
      if dst[id(x2, y2)] != id(x, y):

        var src, dst:auto = 3.repeat(9)
        (i2, j2) = id_rev(dst_inv[id(x, y)])
        move_block(x1, y1, zx, zy, i2, j2)
        src[id_local(x0 - bx, y0 - by)] = -1
        dst[id_local(x0 - bx, y0 - by)] = -1
        src[id_local(x  - bx, y  - by)] = 2
        src[id_local(x1 - bx, y1 - by)] = 1
        src[id_local(zx - bx, zy - by)] = 0
        dst[id_local(x  - bx, y  - by)] = 1
        dst[id_local(x2 - bx, y2 - by)] = 2
        dst[id_local(x1 - bx, y1 - by)] = 0
        let r = find_3_by_3(src, dst)
        for d in r: make_move(d)
      else:
        var src, dst = 3.repeat(9)
        src[id_local(x0 - bx, y0 - by)] = -1
        dst[id_local(x0 - bx, y0 - by)] = -1
        src[id_local(x  - bx, y  - by)] = 2
        src[id_local(x1 - bx, y1 - by)] = 0
        src[id_local(x2 - bx, y2 - by)] = 1
        dst[id_local(x  - bx, y  - by)] = 1
        dst[id_local(x1 - bx, y1 - by)] = 0
        dst[id_local(x2 - bx, y2 - by)] = 2
        let r = find_3_by_3(src, dst)
        for d in r: make_move(d)
      x += dir[d][0]
      y += dir[d][1]
      return (x, y)
    var bx, by: int
    block:
      var
        x0 = 0
        y0 = 0
        n = N
      for i in (N - 3) div 2:
        (x0, y0) = move_block_row((x0, y0), 2, n)
        x0 += dir[3][0];y0 += dir[3][1]
        (x0, y0) = move_block_row((x0, y0), 3, n - 1)
        x0 += dir[0][0];y0 += dir[0][1]
        (x0, y0) = move_block_row((x0, y0), 0, n - 1)
        x0 += dir[1][0];y0 += dir[1][1]
        (x0, y0) = move_block_row((x0, y0), 1, n - 2)
        x0 += dir[2][0];y0 += dir[2][1]
        n -= 2
      bx = x0
      by = y0
      if N mod 2 == 0:
        bx.inc
        (x0, y0) = move_block_row((x0, y0), 2, n)
        x0 += dir[3][0];y0 += dir[3][1]
        (x0, y0) = move_block_row((x0, y0), 3, n - 1)
        x0 += dir[0][0];y0 += dir[0][1]
      doAssert bx == cx and by == cy
    block:
      # (bx, by)を左上とする3 x 3を並べ替え
      var c = 1
      var src_b, dst_b = Seq[9: 0]
      for i in 3:
        for j in 3:
          let
            x = bx + i
            y = by + j
            (x2, y2) = id_rev(dst[id(x, y)])
            i2 = x2 - bx
            j2 = y2 - by
          # (x, y)を(x2, y2)に持っていきたい
          if state_ans.a[x2][y2] != 0:
            src_b[i * 3 + j] = c
            dst_b[i2 * 3 + j2] = c
            c.inc
      var r = find_9_puzzle(src_b, dst_b)
      for d in r:
        make_move(d)
    var ans = ""
    for d in move_log:
      ans.add dir_str[d]
    if ans.len > T: ans = ans[0 ..< T]
    echo ans
    debug initial_sum, actual_sum, ans.len



    #for i in 0 .. N - 4:
    #  # (i, i) 〜 (i, N - 3)
    #  for j in i .. N - 3:
    #    # (i, j)にあるべきものを置く
    #    # (i + 1, j)を空きますにする
    #    move_block(i, j, i + 1, j)
    #    wall[i][j] = '#'
    #  # (i, N - 2), (i, N - 1)について
    #  # (i, N - 2)に(i, N - 1)にあるべきものを置く
    #  block:
    #    let p2 = dst_inv[id(i, N - 1)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(i, N - 2, i + 1, N - 2, i2, j2)
    #    wall[i][N - 2] = '#'
    #  # (i + 1, N - 2)に(i, N - 2)にあるべきものを置く
    #  if dst[id(i, N - 1)] != id(i, N - 2):
    #    let p2 = dst_inv[id(i, N - 2)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(i + 1, N - 2, i + 1, N - 3, i2, j2)
    #    make_move(3)
    #    make_move(2)
    #    make_move(2)
    #    make_move(1)
    #    make_move(1)
    #    make_move(0)
    #    make_move(3)
    #  else:
    #    var
    #      src = @[
    #        -1, 2, 1,
    #         3, 0, 3, 
    #         3, 3, 3]
    #      dst = @[
    #        -1, 1, 2,
    #         3, 0, 3,
    #         3, 3, 3]
    #    let r = find_3_by_3(src, dst)
    #    for d in r: make_move(d)
    #  wall[i][N - 1] = '#'
    #  # let dir_str = "LURD"

    #  # (i + 1, i) 〜 (N - 3, i)
    #  for j in i + 1 .. N - 3:
    #    move_block(j, i, j, i + 1)
    #    wall[j][i] = '#'
    #  # (N - 2, i)と(N - 1, i)について
    #  block:
    #    let p2 = dst_inv[id(N - 1, i)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(N - 2, i, N - 2, i + 1, i2, j2)
    #    wall[N - 2][i] = '#'
    #  if dst[id(N - 1, i)] != id(N - 2, i):
    #    let p2 = dst_inv[id(N - 2, i)]
    #    let (i2, j2) = id_rev(p2)
    #    move_block(N - 2, i + 1, N - 3, i + 1, i2, j2)
    #    make_move(2)
    #    make_move(3)
    #    make_move(3)
    #    make_move(0)
    #    make_move(0)
    #    make_move(1)
    #    make_move(2)
    #  else:
    #    var
    #      src = @[
    #        -1, 3, 3,
    #         2, 0, 3, 
    #         1, 3, 3]
    #      dst = @[
    #        -1, 3, 3,
    #         1, 0, 3,
    #         2, 3, 3]
    #    let r = find_3_by_3(src, dst)
    #    for d in r:
    #      make_move(d)
    #  wall[N - 1][i] = '#'
    #  #set_dst(true)

  # 最後に3 x 3を動かす
  # 最終配置は
  # (N - 3, N - 3), (N - 3, N - 2), (N - 3, N - 1)
  # (N - 2, N - 3), (N - 2, N - 2), (N - 2, N - 1)
  # (N - 1, N - 3), (N - 1, N - 2), (N - 1, N - 1)
  #  block:
  #    proc convert_val(x:int):int =
  #      var (i, j) = id_rev(x)
  #      doAssert i in N - 3 .. N - 1
  #      doAssert j in N - 3 .. N - 1
  #      i -= N - 3
  #      j -= N - 3
  #      if i == 2 and j == 2: return 0
  #      else: return i * 3 + j + 1
  #    var a = Seq[9:int]
  #    for i in 0 ..< 3:
  #      for j in 0 ..< 3:
  #        a[i * 3 + j] = convert_val(dst[id(N - 3 + i, N - 3 + j)])
  #    var r = find_9_puzzle(a)
  #    for d in r:
  #      make_move(d)
  #  var ans = ""
  #  for d in move_log:
  #    ans.add dir_str[d]
  #  if ans.len > T: ans = ans[0 ..< T]
  #  echo ans
  #  debug initial_sum, actual_sum, ans.len

main()
