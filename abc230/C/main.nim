const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:int, B:int, P:int, Q:int, R:int, S:int):
  var ans = Seq[Q - P + 1: '.'.repeat(S - R + 1)]
  for i in P..Q:
    for j in R..S:
      if j - i == B - A:
        let k = i - A
        if k in max(1 - A, 1 - B)..min(N - A, N - B):
          ans[i - P][j - R] = '#'
      if i + j == A + B:
        let k = i - A
        if k in max(1 - A, B - N)..min(N - A, B - 1):
          ans[i - P][j - R] = '#'
  for i in ans.len:
    echo ans[i]
  return


when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  var P = nextInt()
  var Q = nextInt()
  var R = nextInt()
  var S = nextInt()
  solve(N, A, B, P, Q, R, S)
else:
  discard

