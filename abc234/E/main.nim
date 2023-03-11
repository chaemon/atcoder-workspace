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


solveProc solve(X:int):
  var v = Seq[int]
  for d in 1..9:
    for k in -9..9:
      var
        d = d
        x = d
      v.add x
      while true:
        d += k
        if d < 0 or d >= 10: break
        x *= 10
        x += d
        v.add x
        if x >= 10^17:
          break
  v.sort()
  let i = v.lowerBound(X)
  echo v[i]
  discard

when not DO_TEST:
  var X = nextInt()
  solve(X)
else:
  discard

