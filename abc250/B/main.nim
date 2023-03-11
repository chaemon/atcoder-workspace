const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:int, B:int):
  var s = Seq[A * N:'.'.repeat(B * N)]
  for i in A * N:
    for j in B * N:
      let
        x = i div A
        y = j div B
      if (x + y) mod 2 == 1:
        s[i][j] = '#'
  for i in A * N:
    echo s[i]
  discard

when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, A, B)
else:
  discard

