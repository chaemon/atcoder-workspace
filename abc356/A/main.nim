when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, L:int, R:int):
  var ans = Seq[N: int]
  for i in N:
    if i + 1 in L .. R:
      ans[R - (i + 1 - L) - 1] = i + 1
    else:
      ans[i] = i + 1
  echo ans.join(" ")
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt()
  var R = nextInt()
  solve(N, L, R)
else:
  discard

