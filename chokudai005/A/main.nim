include atcoder/extra/header/chaemon_header

import random, times

let start_time = epochTime()

randomize()

let id, N, K = nextInt()
var S = Seq(N, N, int)

for i in 0..<N:
  var s = nextString()
  for j in 0..<N:
    S[i][j] = s[j].ord - '0'.ord



type Input = object
  discard

const dir = [(0, 1), (1, 0), (0, -1), (-1, 0)]

proc dfs(S:var seq[seq[int]], i, j, src, dst:int) =
  S[i][j] = dst
  for (di, dj) in dir:
    let (i2, j2) = (i + di, j + dj)
    if i2 notin 0..<N or j2 notin 0..<N: continue
    if S[i2][j2] != src: continue
    S.dfs(i2, j2, src, dst)


proc eval_board(a:seq[tuple[i, j, c:int]]):auto =
  var S = S
  for (i,j,c) in a:
    assert 1 <= c and c <= K
    let src = S[i][j]
    if src == c: continue
    let dst = c
    S.dfs(i, j, src, dst)
  return S

proc get_score(S:seq[seq[int]]):auto =
  var sc = Seq(K + 1, 0)
  for s in 1..K:
    for i in 0..<N: sc[s] += S[i].count(s)
  return sc.max

proc get_score(a:seq[tuple[i,j,c:int]]):auto =
  eval_board(a).get_score() * 100 - a.len


proc compute_score(input: Input, output: seq[tuple[i,j,c:int]]):int =
  eval_board(output).get_score() * 100 - output.len

#proc solve(input: var Input):seq[int] =
#  var output = newSeq[int]()
#  for _ in 0..<input.D:
#    var
#      max_score = -int.inf
#      best_i = 0
#    for i in 0..<26:
#      output.add(i)
#      let score = compute_score(input, output)
#      if max_score < score:
#        max_score = score
#        best_i = i
#      discard output.pop()
#    output.add(best_i)
#  output

type State = object
  output: seq[tuple[i, j, c:int]]
  score:int

proc cost(a,b:int):int =
  let d = b - a
  d * (d - 1) div 2

proc generate(n:int):seq[tuple[i, j, c:int]] =
  result = newSeq[(int,int,int)]()
  for p in 0..<n:
    let i, j = rand(0..<N)
    let c = rand(1..K)
    result.add((i, j, c))

proc initState(input: Input):State =
  var output = newSeq[tuple[i, j, c:int]]()
  var cnt = Seq(K + 1, 0)
  for i in 0..<N:
    for j in 0..<N:
      cnt[S[i][j]].inc
  var
    max_cnt = -int.inf
    max_i = -1
  for i in 1..K:
    if max_cnt < cnt[i]:
      max_cnt = cnt[i]
      max_i = i
  for i in 0..<N:
    for j in 0..<N:
      if S[i][j] != max_i:
        output.add((i, j, max_i))
#  let output = generate(rand(1..N*N))
  let score = compute_score(input, output)
  return State(output:output, score:score)

proc neighbor(q:seq[tuple[i, j, c:int]]):auto =
  result = q
  let t = rand(0..2)
  if t == 0:
    if q.len > 0:
      let t = rand(0..<q.len)
      let i, j = rand(0..<N)
      let c = rand(1..K)
      result[t] = (i, j, c)
  elif t == 1:
    if result.len > 0:
      result.delete(rand(0..<result.len))
  elif t == 2:
    let t = rand(0..q.len)
    let i, j = rand(0..<N)
    let c = rand(1..K)
    result.insert((i, j, c), t)
  else:
    assert false

proc neighborState(state: State, input: Input):auto =
  var output = state.output.neighbor
  let score = compute_score(input, output)
  return State(output:output, score:score)

#proc change(self: var State, input:Input, d, new_i:int) =
#  proc get_or(a:seq[int], p:int, v:int):int =
#    if p in 0..<a.len: return a[p]
#    else: return v
#  let old_i = self.output[d]
#  block:
#    let
#      p = self.ds[old_i].find(d + 1)
#      prev = self.ds[old_i].get_or(p - 1, 0)
#      next = self.ds[old_i].get_or(p + 1, input.D + 1)
#    self.ds[old_i].delete(p)
#    self.score += (cost(prev, d + 1) + cost(d + 1, next) - cost(prev, next)) * input.c[old_i]
#  block:
#    let
#      p = self.ds[new_i].upper_bound(d + 1)
#      prev = self.ds[new_i].get_or(p - 1, 0)
#      next = self.ds[new_i].get_or(p, input.D + 1)
#    self.ds[new_i].insert(p, d + 1)
#    self.score -= (cost(prev, d + 1) + cost(d + 1, next) - cost(prev, next)) * input.c[new_i]
#    self.score += input.s[d][new_i] - input.s[d][old_i]
#  self.output[d] = new_i

#proc gen_state(self: State, input:Input, d, new)

proc solveAnnealing(input: var Input):auto =
  const
    T0 = 2000.0
    T1 = 600.0
    TL = 2.95
  var
    state = initState(input)
    T = T0
    best = state.score
    best_out = state.output
    cnt = 0
  while true:
    cnt += 1
#    if cnt mod 10 == 0:
    if true or cnt mod 10 == 0:
      let t = (epochTime() - start_time) / TL
      if t >= 1.0: break
      T = T0.pow(1.0 - t) * T1.pow(t)
    let old_score = state.score
#    if rand(1.0) <= 0.5:
    var
      old_state = state
#    state.change(input, d, rand(0..<26))
    state = neighborState(state, input)
#    if old_score > state.score and rand(1.0) > exp((state.score - old_score).float/T):
#    if old_score < state.score and rand(1.0) > exp((state.score - old_score).float/T):
    if old_score < state.score:
      swap(state, old_state)
#      state.change(input, d, old)
#    else:
#      let
#        d1 = rand(0..<input.D - 1)
#        d2 = rand(d1 + 1..<(d1 + 16).min(input.D))
#        (a, b) = (state.output[d1], state.output[d2])
#      state.change(input, d1, b)
#      state.change(input, d2, a)
    if best < state.score:
      best = state.score
      best_out = state.output
  stderr.write("best: ", best)
  best_out

var input = Input()
let best_out = solveAnnealing(input)
#let best_out = input.initState().output

echo best_out.len
for (i, j, c) in best_out:
  echo i + 1, " ", j + 1, " ", c

#echo compute_score(input, best_out)


#import random, times
#
#const TL = 3.0
#let start_time = epochTime()
#

#proc test() =
##  while true:
##    var q = @[(4, 4, 1), (4, 1, 1)]
##    let S = eval_board(q)
##  echo get_score(S)
#  var
#    q = generate(rand(0..N * N))
#    sc = q.get_score()
#  while true:
#    let t = (epochTime() - start_time) / TL
#    if t >= 0.95: break
#    var
#      q2 = q.neighbor()
#      sc2 = q2.get_score()
#    if sc2 > sc:
#      swap(sc, sc2)
#      swap(q, q2)
#  echo q.len
#  for (i, j, c) in q:
#    echo i + 1, " ", j + 1, " ", c
#test()
#
#
