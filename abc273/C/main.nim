when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var
    v = A.sorted.deduplicate(isSorted=true)
    ans = Seq[N: int]
  for i in N:
    let K = v.len - v.upperBound(A[i])
    ans[K].inc
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

