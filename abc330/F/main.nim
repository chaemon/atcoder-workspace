when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/dp/cumulative_sum
import lib/other/binary_search

solveProc solve(N:int, K:int, X:seq[int], Y:seq[int]):
  var
    X = X.sorted
    X_rev = X.reversed
    Y = Y.sorted
    Y_rev = Y.reversed
  for i in N:
    X_rev[i] *= -1
    Y_rev[i] *= -1
  var
    csX, csY = initCumulativeSum[int](N)
    csXrev, csYrev = initCumulativeSum[int](N)
  for i in N:
    csX.add(i, X[i])
    csY.add(i, Y[i])
    csXrev.add(i, X_rev[i])
    csYrev.add(i, Y_rev[i])
  proc f(d:int):bool =
    let d = d
    proc calc(X:seq[int], cs: var auto):int =
      var
        j = 0
        u = int.inf # 移動距離
      for i in N:
        # X[i]からX[i] + dを一辺とする
        # X[j] > X[i] + d
        while j < N and X[j] <= X[i] + d: j.inc
        # 0 ..< iのi個とj ..< X.lenのX.len - j個が移動
        u.min= i * X[i] - cs[0 ..< i] + cs[j ..< N] - (N - j) * (X[i] + d)
      return u

    s := 0
    s += min(calc(X, csX), calc(X_rev, csX_rev))
    s += min(calc(Y, csY), calc(Y_rev, csY_rev))
    return s <= K
  echo f.minLeft(0 .. 10^15)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, K, X, Y)
else:
  discard

