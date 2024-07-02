when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], C:seq[int]):
  var t = initTable[int, seq[int]]()
  for i in N:
    t[C[i]].add A[i]
  var ans = -int.inf
  for k, v in t:
    ans.max=v.min
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    C[i] = nextInt()
  solve(N, A, C)
else:
  discard

