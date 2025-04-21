when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, A:seq[int]):
  var odd, even:seq[int]
  for i in N:
    if A[i] mod 2 == 0:
      even.add A[i]
    else:
      odd.add A[i]
  odd.sort(SortOrder.Descending)
  even.sort(SortOrder.Descending)
  var ans = 0
  if odd.len >= K:
    ans.max=odd[0 ..< K].sum
  if even.len >= K:
    ans.max=even[0 ..< K].sum
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

