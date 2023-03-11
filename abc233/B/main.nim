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


solveProc solve(L:int, R:int, S:string):
  var T = S[L..<R]
  T.reverse
  echo S[0..<L] & T & S[R..^1]
  discard

when not DO_TEST:
  var L = nextInt() - 1
  var R = nextInt()
  var S = nextString()
  solve(L, R, S)
else:
  discard

