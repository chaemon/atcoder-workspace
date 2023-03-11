include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils
import bitops

proc main():void =
  let N, M = nextInt()
  let (A, B, C) = unzip(M, (nextInt() - 1, nextInt() - 1, nextInt() - 1))
  var isValid = Seq[2^N: bool]
  ans := 0
  for b in 1..<2^N:
    valid := true
    for i in 0..<M:
      if b[A[i]] and b[B[i]] and b[C[i]]: valid = false;break
    isValid[b] = valid
  for b in 0..<2^N:
    if not isValid[b]: continue
    t := 0
    for i in 0..<N:
      if b[i]: continue
      if not isValid[b or [i]]: t.inc
    ans.max=t
  echo ans
  return

main()
