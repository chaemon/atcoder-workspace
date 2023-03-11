when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(N, Q: int):
  var
    dsu = initDSU(N + Q)
    k = N
    box = Seq[N + Q: -1] # box[i]はボールiの入っているbox, ただしiはリーダーでなくてはならない
    box_leader = Seq[N: -1] # box_leader[i]は箱iのリーダー, 箱iが空の場合は-1となる
  for i in N:
    box[i] = i
    box_leader[i] = i
  for _ in Q:
    let t = nextInt()
    if t == 1:
      let
        X, Y = nextInt() - 1
        x = box_leader[X]
        y = box_leader[Y]
      if x == -1:
        if y != -1:
          box[y] = X
          box_leader[X] = y
      elif y == -1:
        discard
      else:
        let b = box[x]
        dsu.merge(X, Y)
        let l = dsu.leader(X)
        box[l] = b
        box_leader[b] = l
      box_leader[Y] = -1
    elif t == 2:
      let X = nextInt() - 1
      var l = box_leader[X]
      if l == -1:
        box[k] = X
      else:
        dsu.merge(l, k)
      box_leader[X] = dsu.leader(k)
      box[dsu.leader(k)] = X
      k.inc
    elif t == 3:
      let X = nextInt() - 1
      echo box[dsu.leader(X)] + 1
  discard

when not defined(DO_TEST):
  let N, Q = nextInt()
  solve(N, Q)
else:
  discard

