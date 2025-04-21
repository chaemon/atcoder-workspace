when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/mincostflow

solveProc solve(N, M:int, A, B, R:seq[int]):
  var
    g = initMCFGraph[int, int](N * 3 + 3 + N + 2)
    round = N * 3 # ラウンドu, u + 1, u + 2
    stick = round + 3 # stick, stick + 1, ..., stick + N - 1を使う
    s = stick + N
    t = s + 1
    RMAX = R.max + 1
  for i in 3:
    g.addEdge(s, round + i, M, 0)
  for i in 3: # ラウンド
    for j in N:
      let
        p = A[j] * B[j]^(i + 1) mod R[i]
        u = i * N + j
      g.addEdge(round + i, u, 1, RMAX - p)
      g.addEdge(u, stick + j, 1, 0)
  for j in N:
    var p = 0
    for i in 3:
      let pnext = A[j] * B[j]^(i + 1)
      g.addEdge(stick + j, t, 1, pnext - p)
      p = pnext
  let c = g.flow(s, t).cost
  echo RMAX * M * 3 - c
  discard

var
  N = nextInt()
  M = nextInt()
  A = newSeqWith(N, nextInt())
  B = newSeqWith(N, nextInt())
  R = newSeqWith(3, nextInt())

solve(N, M, A, B, R)
