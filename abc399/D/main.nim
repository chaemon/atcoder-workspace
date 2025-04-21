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
  var
    pos = Seq[N: seq[int]]
    ans = 0
  for i in A.len:
    pos[A[i]].add i
  for i in N:
    if abs(pos[i][0] - pos[i][1]) == 1: continue
    for d0 in [-1, 1]:
      let i0 = pos[i][0] + d0
      if i0 notin 0 ..< N*2 or A[i0] < i: continue
      for d1 in [-1, 1]:
        let j0 = pos[i][1] + d1
        if j0 notin 0 ..< N*2 or A[i0] != A[j0] or i0 == j0 or abs(i0 - j0) == 1: continue
        ans.inc
  echo ans

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var A = newSeqWith(2*N, nextInt())
    solve(N, A)
else:
  discard

