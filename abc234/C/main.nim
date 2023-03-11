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
import lib/other/bitutils

solveProc solve(K:int):
  var K = K
  var ans = ""
  while K > 0:
    if K mod 2 == 1:
      ans &= '2'
    else:
      ans &= '0'
    K.div=2
  ans.reverse
  echo ans
  discard

when not DO_TEST:
  var K = nextInt()
  solve(K)
else:
  discard

