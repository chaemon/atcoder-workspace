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


solveProc solve(X:int, Y:int):
  var X = X
  for c in 0..10000:
    if X >= Y:
      echo c;return
    X += 10
  discard

when not DO_TEST:
  var X = nextInt()
  var Y = nextInt()
  solve(X, Y)
else:
  discard

