when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, M:int, P:seq[int]):
  proc calc(p:int):int = # 個数
    if p > M: return int.inf
    var s = 0
    result = 0
    for i in N:
      let m = p div P[i]
      # 2 * k - 1 <= m
      let d = (m + 1) div 2
      result += d
      if d > 10^9: # d * d * P[i]を足すとMを超える
        return int.inf
      if d == 0: continue
      let u = d * d
      if 10^18 div u < P[i]:
        block:
          if not ((10^18 + u - 1) div u < P[i]):
            doAssert false
        return int.inf
      s += d * d * P[i]
      if s > M: return int.inf
  proc f(p:int):bool =
    calc(p) < int.inf
  let p = f.maxRight(0 .. M + 1)
  echo calc(p)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, M, P)
else:
  discard

