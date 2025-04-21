when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var ans = Seq[N: '?'.repeat(N)]
  for i in 1 .. N:
    let j = N + 1 - i
    if i <= j:
      var c:char
      if i mod 2 == 0:
        c = '.'
      else:
        c = '#'
      for x in i .. j:
        for y in i .. j:
          ans[x - 1][y - 1] = c
  for i in N:
    echo ans[i]
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

