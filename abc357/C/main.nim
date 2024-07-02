when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var ans = Seq[3^N: '.'.repeat(3^N)]
  proc calc(i, j, d:int) =
    if d == 1:
      ans[i][j] = '#';return
    let d2 = d div 3
    for s in 3:
      for t in 3:
        if s == 1 and t == 1: continue
        calc(i + s * d2, j + t * d2, d2)
  calc(0, 0, 3^N)
  for i in ans.len:
    echo ans[i]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

