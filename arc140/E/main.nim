const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

static:
  discard staticExec("nim cpp --gc:none main.nim")

include lib/header/chaemon_header

const P = 23

solveProc solve(N:int, M:int):
  var ans = Seq[P^2, P^2: int]
  for i in P:
    for j in P:
      for x in P:
        for y in P:
          let k = (x + y) mod P
          ans[x * P + i][y * P + j] = (i * j + k) mod P
  ans = ans[0 ..< N]
  for i in N:
    ans[i] = ans[i][0 ..< M]
  for i in ans.len:
    for j in ans[i].len:
      ans[i][j].inc
  for i in ans.len:
    echo ans[i].join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

