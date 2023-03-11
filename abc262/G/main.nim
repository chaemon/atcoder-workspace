const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

var dp = Array[51, 51, 50, 50: Option[int8]] # i ..< j, min, max

solveProc solve(N:int, a:seq[int]):
  proc calc(i, j, min_val, max_val:int):int =
    ret =& dp[i][j][min_val][max_val]
    if ret.isSome: return ret.get
    result = 0
    if i < j:
      result = 0
      for k in i ..< j:
        # kを最初の山に使う
        if a[k] notin min_val .. max_val: continue
        for l in k + 1 .. j:
          # k ..< lが最初の山
          result.max = calc(k + 1, l, min_val, a[k]) + calc(l, j, a[k], max_val) + 1
    ret = (result.int8).some
  echo calc(0, N, 0, 49)
  discard

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, nextInt() - 1)
  solve(N, a)
else:
  discard
