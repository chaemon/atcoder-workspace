when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, D:int, X:seq[int], Y:seq[int]):
  var p = Seq[tuple[x, y:int]]
  for i in N:
    p.add (X[i], Y[i])
  p.sort
  var (X, Y) = (X, Y)
  for i in N:
    X[i] = p[i].x
    Y[i] = p[i].y
  var v = Seq[int]
  template x(i:int):int = X[i]
  template y(i:int):int = Y[i]
  template z(i:int):int = X[i] - Y[i]
  proc cmp_y(i, j:int):bool = y(i) < y(j) or (y(i) == y(j) and i < j)
  proc cmp_z(i, j:int):bool = z(i) < z(j) or (z(i) == z(j) and i < j)
  proc dist_x(i, j:int):int = abs(x(i) - x(j))
  proc dist_y(i, j:int):int = abs(y(i) - y(j))
  proc dist_z(i, j:int):int = abs(z(i) - z(j))
  proc dist(i, j:int):int = max([dist_x(i, j), dist_y(i, j), dist_z(i, j)])
  var pow2 = @[mint(1)]
  while pow2.len <= N + 1:
    pow2.add pow2[^1] * 2
  ans := mint(0)
  for i in N: # Y[i]: 最小
    for j in N: # z(j) = X[j] - Y[j]: 最小
      if dist(i, j) > D: continue
      if i != j and (cmp_y(j, i) or cmp_z(i, j)): continue
      v.setLen(0)
      ii := -1
      ji := -1
      for k in N:
        if i == k or j == k:
          if i == k: ii = v.len
          if j == k: ji = v.len
          v.add k
        else:
          if cmp_y(k, i) or cmp_z(k, j): continue
          if dist(k, i) > D or dist(k, j) > D: continue
          v.add k
      var
        ri = 0
      # li ..< ri
      for li in 0 ..< v.len:
        while ri < v.len and X[v[ri]] - X[v[li]] <= D: ri.inc
        if ii in li ..< ri and ji in li ..< ri:
          c := ri - li - 1 # iの分
          if ii != ji: c.dec
          # liは必ず選ぶ
          if li != ii and li != ji: c.dec
          #ans += mint(2)^c
          ans += pow2[c]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, D, X, Y)
else:
  discard

