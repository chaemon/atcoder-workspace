const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

proc solve(S:string) =
  echo (S[0].ord - '0'.ord) * (S[2].ord - '0'.ord)
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

