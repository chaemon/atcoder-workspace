when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[seq[int]]):
  for i in N:
    var a:seq[int]
    for j in N:
      if A[i][j] == 1:
        a.add j + 1
    echo a.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, A)
else:
  discard

