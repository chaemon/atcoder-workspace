const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, K:int, A:seq[int]):
  proc f(p:int):bool =
    # p個のプロジェクトを作れるか?
    # 各部署からp人出す
    s := 0
    for i in N:
      s += min(p, A[i])
    return s >= p * K
  echo f.maxRight(1 .. (A.sum + 1).floorDiv K)
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

