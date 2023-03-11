const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:string):
  var a = Seq[N: 0]
  var num = 0
  for i in 0..<X.len:
    if X[i] == '0': a[X.len - 1 - i] = 0
    else: a[X.len - 1 - i] = 1; num.inc
  proc subt1() =
    assert num > 0
    for i in 0..<N:
      if a[i] == 1: a[i] = 0; num.dec; return
      else: a[i] = 1; num.inc
  subt1()
  var ans = "1"
  for i in 0..<N:
    if num == 0: echo ans; return
    if a[N - 1 - i] == 0:
      ans.add '0'
      subt1()
    else:
      ans.add '1'
      a[N - 1 - i] = 0
      num.dec
  return

when not DO_TEST:
  var N = nextInt()
  var X = nextString()
  solve(N, X)
else:
  discard

