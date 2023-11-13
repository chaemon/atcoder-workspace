when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var t = initTable[int, seq[int]]()
  for i in N:
    if A[i] notin t:
      t[A[i]] = newSeq[int]()
    t[A[i]].add i
  var ans = 0
  for k, v in t:
    for i in v.len - 1:
      # v[i], v[i + 1]
      ans += (v[i + 1] - v[i] - 1) * (i + 1) * (v.len - i - 1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

