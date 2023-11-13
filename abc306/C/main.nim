when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  Pred A
  var v = Seq[N: seq[int]]
  for i in 3 * N:
    v[A[i]].add i
  var ans = (0 ..< N).toSeq
  ans.sort do (i, j:int) -> int:
    cmp(v[i][1], v[j][1])
  for i in ans.mitems:i.inc
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(3*N, nextInt())
  solve(N, A)
else:
  discard

