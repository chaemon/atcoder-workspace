const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, W:int, A:seq[int]):
  var a = Seq[10^6*3 + 1: false]
  for i in N:
    a[A[i]] = true
    for j in i+1..<N:
      a[A[i] + A[j]] = true
      for k in j+1..<N:
        a[A[i] + A[j] + A[k]] = true
  echo a[1..W].count(true)
  discard

when not DO_TEST:
  var N = nextInt()
  var W = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, W, A)
else:
  discard

