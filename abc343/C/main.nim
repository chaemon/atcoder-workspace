when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var u:seq[int]
  for x in 1 .. 1000000:
    var
      K = x^3
      d:seq[int]
      isOK = true
    block:
      var K = K
      while K > 0:
        d.add K mod 10
        K.div=10
    for i in d.len:
      if d[i] != d[d.len - 1 - i]:
        isOK = false
    if isOK: u.add K
  var t = u.upperBound(N)
  echo u[t - 1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

