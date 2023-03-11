const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/math
import lib/other/binary_search

# Failed to predict input format
solveProc solve(S, K:int):
  var p = 2
  while true:
    if S mod p != 0: break
    p.inc
  var
    min_val = Seq[p: int.inf] # a[r]: mod pでrになるもののうち作れる最小値
    basis = @[p]
  let
    r0 = S mod p
  min_val[0] = 0
  while true:
    var candidate = Seq[int]
    for r in 1..<p:
      # a = k * p + rを追加, kの最小値を求める
      var kmin = 1
      for t in 1..<p:
        if (t * r) mod p == 0: continue
        let r2 = (S - t * r).floorMod p
        if min_val[r2] == int.inf: continue
        # t * (k * p + r) + min_val[r2] > S とならなくてはならない
        let d = S - min_val[r2] - r * t
        if d >= 0:
          # t * p * k > d
          kmin.max= d div (t * p) + 1
      let a = kmin * p + r
      if a * 2 < S and a < min_val[r]:
        candidate.add a
    if candidate.len == 0:
      break
    candidate.sort
    let a = candidate[0]
    basis.add a
    # update
    var min_val2 = Seq[p: int.inf]
    For (s := a; t := 1), t < p and s < int.inf, (s += a; t.inc):
      for r in 0 ..< p:
        if min_val[r] == int.inf: continue
        min_val[(r + s) mod p].min= min_val[r] + s
    doAssert min_val[r0] > S
  proc query(s:Slice[int]):int = # l ..< r: Slice[int]に含まれる
    let (l, r) = (s.a, s.b + 1)
    if l >= r: return 0
    if l > 0:
      return query(0 ..< r) - query(0 ..< l)
    # l == 0
    if (r - 1) * 2 > S:
      var
        m0 = if S mod 2 == 0: S div 2 - 1 else: S div 2
        m1 = S - m0
      # 0 .. m0 と m1 ..< rに分ける
      # 後者はS - (r - 1) .. S - m1の裏
      result = query(0 .. m0)
      if m1 < r:
        result += r - m1 - query(S - (r - 1) .. S - m1)
      return
    # l == 0 and r * 2 <= S
    # 0 .. r - 1
    result = 0
    for t in 0..<p:
      if min_val[t] > r - 1: continue
      # min_val[t] + k * p <= r - 1となる範囲?
      result += (r - 1 - min_val[t]) div p + 1
  if query(1..S) < K:
    echo -1;return
  proc f(r:int):bool = query(1..r) >= K
  echo f.minLeft(1..S)
  discard

when not DO_TEST:
  let T = nextInt()
  for _ in T:
    let S, K = nextInt()
    solve(S, K)
else:
  discard

