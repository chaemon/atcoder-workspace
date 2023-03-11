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


# Failed to predict input format
solveProc solve():
  discard

when not DO_TEST:
  solve()
else:
  discard

