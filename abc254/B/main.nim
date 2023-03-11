const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int):
  var a = @[1]
  echo a.join(" ")
  for i in N - 1:
    var a2 = Seq[i + 2: 0]
    for j in a2.len:
      if j == 0 or j == a2.len - 1:
        a2[j] = 1
      else:
        a2[j] = a[j - 1] + a[j]
    swap a, a2
    echo a.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

