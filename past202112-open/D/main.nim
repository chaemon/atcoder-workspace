when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var v:seq[tuple[s, m, i:int]]
  for i in N:
    v.add (-A[i] - B[i], -A[i], i)
  v.sort()
  var ans = Seq[int]
  for i in N:
    ans.add v[i].i + 1
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
else:
  discard

