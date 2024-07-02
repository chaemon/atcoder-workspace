when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  for i in N:
    var
      ans = -1
      ans_j = -1
    for j in N:
      let d = (X[i] - X[j])^2 + (Y[i] - Y[j])^2
      if ans < d:
        ans = d
        ans_j = j
    echo ans_j + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
else:
  discard

