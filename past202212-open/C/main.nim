when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var s:seq[int]
  for i in N:
    for j in i + 1 ..< N:
      for k in j + 1 ..< N:
        s.add A[i] * A[j] * A[k]
  s.sort
  echo s.deduplicate(isSorted = true).len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

