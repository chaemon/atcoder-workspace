when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, D:seq[int]):
  proc digits(N:int):seq[int] =
    var N = N
    while N > 0:
      result.add N mod 10
      N.div=10
  ans := 0
  for i in N:
    for j in 1 .. D[i]:
      if (digits(i + 1) & digits(j)).toSet.len == 1:
        ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = newSeqWith(N, nextInt())
  solve(N, D)
else:
  discard

