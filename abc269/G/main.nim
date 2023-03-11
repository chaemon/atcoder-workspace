when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/slide_min

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var ct = initTable[int, int]()
  for i in N:
    let d = B[i] - A[i]
    ct[d].inc
  var s = A.sum
  var dp = Seq[M + 1: int.inf]
  dp[s] = 0
  var a = newSeqOfCap[int](dp.len)
  for d, n in ct:
    if d == 0: continue
    let
      D = abs(d)
    for r in 0 ..< D:
      a.setLen(0)
      block:
        i := r
        while i < dp.len:
          a.add dp[i]
          i += D
      var u = Seq[int]
      if d > 0:
        for i in a.len:
          if a[i] != int.inf:
            a[i] += a.len - 1 - i
        # aをslideminでうつす
        u = a.slideMin(n + 1, false)
        # uの長さはa.len - n
        for i in a.len:
          if u[i] != int.inf:
            u[i] -= a.len - 1 - i
      else:
        for i in a.len:
          if a[i] != int.inf:
            a[i] += i
        a.reverse
        # aをslideminでうつす
        u = a.slideMin(n + 1, false)
        u.reverse
        doAssert u.len == a.len
        for i in a.len:
          if u[i] != int.inf:
            u[i] -= i
      # uのデータを反映
      block:
        i := r
        j := 0
        while i < dp.len:
          dp[i] = u[j]
          i += D
          j.inc
  dp.applyIt(if it == int.inf: -1 else: it)
  echo dp.join("\n")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard
