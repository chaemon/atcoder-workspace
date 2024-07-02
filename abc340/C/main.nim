when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var t = initTable[int, int]()
  proc calc(n:int):int =
    if n in t: return t[n]
    if n == 1:
      result = 0
    else:
      let m = n div 2
      result = calc(m) + calc(n - m) + n
    t[n] = result
  echo calc(N)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

