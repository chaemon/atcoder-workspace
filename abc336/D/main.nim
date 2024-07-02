when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search
import lib/dp/dual_cumulative_sum

solveProc solve(N:int, A:seq[int]):
  proc f(k:int):bool = # サイズkのピラミッド数列が作れるか
    var cs = initDualCumulativeSum[int](N)
    for i in N:# iを頂上にするとき
      # iより左のjを頂上としたとき、
      # i番目の高さはk - (i - j)なのでA[i]はこれとおなじか高いならOK
      # つまりA[i] >= k - (i - j)ならOKだがそうでないとだめ
      # A[i] - k + i < jの範囲がだめ
      let l = max(0, A[i] - k + i + 1)
      if l <= i:
        cs.add(l .. i, 1)
      # iより右のjを頂上
      # i番目の高さはk - (j - i)なのでA[i]はこれと同じか高いならOK
      # つまりA[i] >= k - (j - i)
      # j < k + i - A[i]
      let r = min(N - 1, k + i - A[i] - 1)
      if r >= i:
        cs.add(i .. r, 1)
    for i in N:
      if i - (k - 1) notin 0 ..< N: continue
      if i + (k - 1) notin 0 ..< N: continue
      if cs[i] == 0: return true
    return false
  echo f.maxRight(1 .. N)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

