when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int]):
  var a = Seq[N + 1: false]
  for i in M:
    a[A[i]] = true
  var ans:seq[int]
  for i in 1 .. N:
    if not a[i]: ans.add i
  echo ans.len
  echo ans.join(" ")
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, nextInt())
  solve(N, M, A)
else:
  discard

