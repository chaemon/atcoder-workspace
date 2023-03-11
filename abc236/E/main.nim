const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search
import lib/other/binary_search_float
import lib/other/bitutils
import random

proc compare(s, t:string, error:float = NaN):bool =
  if error == NaN:
    return s == t
  else:
    var
      s = s.split("\n")
      t = t.split("\n")
    if s.len != t.len: return false
    for i in 0 ..< s.len:
      var s = s[i].split()
      var t = t[i].split()
      if s.len != t.len: return false
      for j in 0 ..< s.len:
        if s[j].len == 0:
          if t[j].len != 0: return false
        elif t[j].len == 0:
          return false
        else:
          var fs = s[j].parseFloat
          var ft = t[j].parseFloat
          if abs(fs - ft) > error and abs(fs - ft) > min(abs(ft), abs(fs)) * error: return false
  return true

solveProc solve(N:int, A:seq[int]):
  # average
  proc f(M:float):bool =
    var A = A.mapIt(it.float - M)
    var dp = Array[2: -float.inf]
    # i = 0, 1
    dp[0].max= A[1]
    dp[0].max= A[0] + A[1]
    dp[1].max= A[0]
    for i in 2..<N:
      var dp2 = Array[2: -float.inf]
      # select
      dp2[0].max= dp[0] + A[i]
      dp2[0].max= dp[1] + A[i]
      # not select
      dp2[1].max= dp[0]
      swap dp, dp2
    if dp[0] >= 0.0 or dp[1] >= 0.0: return true
    return false
  proc g(M:int):bool =
    var A = A.mapIt(
      if it - M >= 0: 1
      else: -1
    )
    var dp = Array[2: -int.inf]
    # i = 0, 1
    dp[0].max= A[1]
    dp[0].max= A[0] + A[1]
    dp[1].max= A[0]
    for i in 2..<N:
      var dp2 = Array[2: -int.inf]
      # select
      dp2[0].max= dp[0] + A[i]
      dp2[0].max= dp[1] + A[i]
      # not select
      dp2[1].max= dp[0]
      swap dp, dp2
    if dp[0] >= 1 or dp[1] >= 1: return true
    return false

  echo f.maxRight(0.0..(10^9).float)
  echo g.maxRight(0..10^9)
  Naive:
    var
      ans_average = -float.inf
      ans_median = -int.inf
    for b in 2^N:
      ok := true
      for i in N - 1:
        if b[i] == 0 and b[i + 1] == 0: ok = false
      if not ok: continue
      v := Seq[int]
      for i in N:
        if b[i] == 1:
          v.add A[i]
      v.sort
      ans_average.max= v.sum / v.len
      ans_median.max= v[(v.len - 1) div 2]
    echo ans_average
    echo ans_median
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  for _ in 100:
    let N = 10
    A := Seq[N: random.rand(1..10^9)]
    test(N, A, 0.0001)
