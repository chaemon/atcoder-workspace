import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL 
Please use Nim-ACL
Please use Nim-ACL

const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/dp/cumulative_sum

solveProc solve(X:string):
  var cs = initCumulativeSum[int](X.len)
  for i in 0..<X.len:
    cs[i] = X[i].ord - '0'.ord
  var ans = newSeq[int]()
  var
    r = 0
    d = 0
  while true:
    if d < X.len:
      r += cs[0 ..< X.len - d]
    else:
      if r == 0: break
    ans.add r mod 10
    r.div= 10
    d.inc
  ans.reverse
  echo ans.join()
  discard

when not DO_TEST:
  var X = nextString()
  solve(X)
else:
  discard

