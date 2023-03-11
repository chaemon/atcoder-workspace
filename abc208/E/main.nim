const
  DO_CHECK = true
  DEBUG = false
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/extra/math/convert_base

# default-table {{{
import tables

proc `[]`[A, B](self: var Table[A, B], key: A): var B =
  discard self.hasKeyOrPut(key, B.default)
  tables.`[]`(self, key)
#}}}

solveProc solve(N:int, K:int):
  var a = N.toSeq
  var ans = 0
  block:
    var dp = Array[2: Table[int, int]]
    dp[0][1] = 1
    for i in countDown(a.len - 1, 0):
      let d = a[i]
      var dp2 = Array[2: Table[int, int]]
      var s: int
      if i == a.len - 1: s = 1
      else: s = 0
      # 0
      for p, n in dp[0]:
        # set value 0..<d
        for i in s..<d:
          let p2 = p * i
          if p2 <= K:
            dp2[1][p2] += n
          else:
            dp2[1][K + 1] += n
        # set value d
        let p2 = p * d
        if p2 <= K:
          dp2[0][p2] += n
        else:
          dp2[0][K + 1] += n
      # 1
      for p, n in dp[1]:
        for i in 0..9:
          let p2 = p * i
          if p2 <= K:
            dp2[1][p2] += n
          else:
            dp2[1][K + 1] += n
      swap dp, dp2
    for i in 0..1:
      for p, n in dp[i]:
        if p <= K: ans += n
  for d0 in 1..<a.len:
    var dp: Table[int, int]
    dp[1] = 1
    for i in countDown(d0 - 1, 0):
      var dp2: Table[int, int]
      var s: int
      if i == d0 - 1: s = 1
      else: s = 0
      # 0
      for p, n in dp:
        # set value 0..<d
        for i in s..9:
          let p2 = p * i
          if p2 <= K:
            dp2[p2] += n
          else:
            dp2[K + 1] += n
      swap dp, dp2
    debug d0, dp
    for p, n in dp:
      if p <= K: ans += n
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}

