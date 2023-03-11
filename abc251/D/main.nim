const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(W:int):
  var ans = Seq[int]
  for d in [1, 10^2, 10^4]:
    for i in d .. d * 100 >> d:
      ans.add i
  echo ans.len
  echo ans.join(" ")
  discard

when not DO_TEST:
  var W = nextInt()
  solve(W)
else:
  discard

