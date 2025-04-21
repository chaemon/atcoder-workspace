when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var
    B:seq[int]
    prev = initTable[int, int]()
  for i in N:
    if A[i] notin prev:
      B.add -1
    else:
      B.add prev[A[i]]
    prev[A[i]] = i + 1
  echo B.join(" ")
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

