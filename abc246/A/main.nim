const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(x:seq[int], y:seq[int]):
  var a, b = initTable[int, int]()
  for i in 3:
    if x[i] notin a: a[x[i]] = 0
    a[x[i]].inc
  for i in 3:
    if y[i] notin b: b[y[i]] = 0
    b[y[i]].inc
  var ans_x, ans_y:int
  for k, v in a:
    if v == 1:
      ans_x = k
  for k, v in b:
    if v == 1:
      ans_y = k
  echo ans_x, " ", ans_y
  discard

when not DO_TEST:
  var x = newSeqWith(3, 0)
  var y = newSeqWith(3, 0)
  for i in 0..<3:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(x, y)
else:
  discard

