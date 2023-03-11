include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils
import bitops

const DEBUG = true

block main:
  let N, M = nextInt()
  var cp = Seq[N: seq[tuple[Y, Z:int]]]
  for i in 0..<M:
    var X, Y, Z = nextInt()
    X.dec;Y.dec
    cp[X].add((Y, Z))
  var dp = Seq[2^N: int]
  dp[0] = 1
  for n in 0..<N:
    var dp2 = Seq[2^N: int]
    for b in 0..<2^N:
      for i in 0..<N:
        if b[i] == 1: continue
        let b2 = b xor [i]
        dp2[b2] += dp[b]
    for b in 0..<2^N:
      var valid = true
      # n + 1 letters
      for (Y, Z) in cp[n]:
        if b[0..Y].popCount > Z:
          valid = false;break
      if not valid: dp2[b] = 0
    swap(dp, dp2)
  echo dp[2^N - 1]
  discard

