when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import heapqueue

let dir = [(0, 1), (1, 0), (0, -1), (-1, 0)]

solveProc solve(S:seq[seq[int]], T:seq[seq[int]]):
  var
    S = S[0] & S[1] & S[2] & S[3]
    T = T[0] & T[1] & T[2] & T[3]
  for i in 16:
    if S[i] == -1: S[i] = 15
    else: S[i].dec
  for i in 16:
    if T[i] == -1: T[i] = 15
    else: T[i].dec
  proc decode(d:int):seq[int] =
    result = newSeq[int](16)
    var
      d = d
      mask = (1 shl 4) - 1
    for i in 16:
      result[i] = d and mask
      d.shr=4
  proc encode(a:seq[int]):int =
    result = 0
    var p = 1
    for i in 16:
      result.xor= a[i] shl (i * 4)
  var goal_pos = newSeq[tuple[x, y:int]](16)
  for i in 4:
    for j in 4:
      let k = i * 4 + j
      if T[k] == 15: continue
      goal_pos[T[k]] = (i, j)
  proc h(a: seq[int]):int =
    result = 0
    for i in 4:
      for j in 4:
        let k = i * 4 + j
        if a[k] == 15: continue
        result += abs(i - goal_pos[a[k]].x) + abs(j - goal_pos[a[k]].y)

  var
    open_s, close_s = initSet[int]()
    f, g = initTable[int, int]()
    open_q = initHeapQueue[tuple[f, e:int]]()
    start_e = S.encode
    goal_e = T.encode
  open_s.incl(start_e)
  f[start_e] = h(S)
  open_q.push (f[start_e], start_e)
  while true:
    #debug open_s.len, open_q.len
    if open_s.len == 0: break
    var
      (fn, ne) = open_q.pop()
    if ne == goal_e:
      # found
      if fn > 30:
        echo -1
      else:
        echo fn
      return
    var
      n = ne.decode()
      x, y:int
    g[ne] = f[ne] - h(n)
    let gn = g[ne]
    for i in 4:
      for j in 4:
        if n[i * 4 + j] == 15:
          x = i; y = j
    for (dx, dy) in dir:
      let
        x2 = x + dx
        y2 = y + dy
      if x2 notin 0 ..< 4 or y2 notin 0 ..< 4: continue
      swap n[x * 4 + y], n[x2 * 4 + y2]
      let f2 = gn + 1 + h(n) # h(n)は本当はh(m): トリッキー
      if f2 > 30: continue
      let me = n.encode
      if me in open_s:
        if f2 < f[me]:
          f[me] = f2
      elif me in close_s:
        if f2 < f[me]:
          f[me] = f2
          open_s.incl me
          open_q.push (f[me], me)
      else:
        f[me] = f2
        open_s.incl me
        open_q.push (f[me], me)
      swap n[x * 4 + y], n[x2 * 4 + y2]
  echo -1
  doAssert false
  discard


when not defined(DO_TEST):
  var S = newSeqWith(4, newSeqWith(4, nextInt()))
  var T = newSeqWith(4, newSeqWith(4, nextInt()))
  solve(S, T)
else:
  discard

