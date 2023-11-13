when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var v:seq[int]
  for n in 100 .. 919:
    var
      n0 = n
      n = n
      d:seq[int]
    for i in 3:
      d.add n mod 10
      n.div=10
    d.reverse
    if d[0] * d[1] == d[2]:
      v.add n0
  echo v[v.lowerBound(N)]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

