when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/dp/dual_cumulative_sum

type Range = tuple[l, r:int] # l ..< r

solveProc solve(N:int, X:seq[int], L:seq[int]):
  proc calc(L, k:int):seq[Range] = # 距離L以内にk個以上宝がある範囲を返す
    for i in 0 .. N - k:
      # X[i]が一番左である。
      #   X[i - 1] < x - L, x - L <= X[i]
      # X[i + k - 1]も範囲に含まれる。
      #   X[i + k - 1] <= x + L
      # となるxを探す
      var
        l = -int.inf
        r = int.inf
      if i > 0:
        l.max=X[i - 1] + L + 1
      l.max=X[i + k - 1] - L
      r.min=X[i] + L + 1
      # l ..< rが条件をみたす
      if l < r:
        result.add (l, r)
    result.sort
    var a = result
    result.setLen(0)
    var
      prev_l, prev_r:int
    for i, (l, r) in a:
      if i == 0:
        prev_l = l
        prev_r = r
      else:
        if prev_r < l:
          result.add (prev_l, prev_r)
          prev_l = l
          prev_r = r
        else:
          prev_r = r
    result.add (prev_l, prev_r)
  var
    rss: seq[seq[Range]]
    v:seq[int]
  for i in N:
    let rs = calc(L[i], i + 1)
    rss.add rs
    for (l, r) in rs:
      v.add l;v.add r
  v.sort
  v = v.deduplicate(isSorted = true)
  var cs = initDualCumulativeSum[int](v.len)
  for rs in rss:
    for (l, r) in rs:
      let
        li = v.lowerBound(l)
        ri = v.lowerBound(r)
      cs.add(li ..< ri, 1)
  var ans = 0
  for i in v.len:
    if cs[i] == N:
      ans += v[i + 1] - v[i]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, nextInt())
  var L = newSeqWith(N, nextInt())
  solve(N, X, L)
else:
  discard

