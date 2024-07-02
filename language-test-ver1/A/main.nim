when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, c:string):
  ans_max := -int.inf
  ans_min := int.inf
  for a in ['1', '2','3','4']:
    ans_max.max=c.count(a)
    ans_min.min=c.count(a)
  echo ans_max, " ", ans_min
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var c = nextString()
  solve(N, c)
else:
  discard

