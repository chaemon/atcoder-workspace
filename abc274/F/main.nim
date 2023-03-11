when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const EPS = 1e-9

solveProc solve(N:int, A:int, W:seq[int], X:seq[int], V:seq[int]):
  ans := 0
  for i in N:
    # 魚iを左端にする
    # X[i] + V[i] * t <= X[j] + V[j] * t <= X[i] + V[i] * t + A
    # となる範囲を求める
    type P = (float, int)
    var v = Seq[P]
    v.add (0.0, W[i])
    #v.add (float.inf, -W[i])
    for j in N:
      if i == j: continue
      var tl, tr: float
      if V[i] != V[j]:
        let v = V[j] - V[i]
        tl = (X[i] - X[j]) / v
        tr = (X[i] - X[j] + A) / v
        if v < 0:
          swap tl, tr
      else:
        if X[j] in X[i] .. X[i] + A:
          tl = 0.0
          tr = float.inf
        else:
          tl = -float.inf
          tr = -float.inf
      if tr < 0.0:
        # do nothing
        discard
      else:
        tl.max= 0.0
        if tl < float.inf:
          v.add (tl, W[j])
        if tr < float.inf:
          v.add (tr, -W[j])
    v.sort do (x, y:P) -> int:
      if abs(x[0] - y[0]) < EPS : cmp(y[1], x[1])
      else: cmp(x[0], y[0])
    var c = 0
    for (x, w) in v:
      c += w
      ans.max=c
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var W = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  var V = newSeqWith(N, 0)
  for i in 0..<N:
    W[i] = nextInt()
    X[i] = nextInt()
    V[i] = nextInt()
  solve(N, A, W, X, V)
else:
  discard

