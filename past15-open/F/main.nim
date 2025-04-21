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
    v:seq[tuple[A, i:int]]
    B = Seq[N: int]
  for i in N:
    v.add (A[i], i)
  v.sort
  for i in N:
    let (A, j) = v[i]
    B[j] = i + 1
  echo B.join(" ")

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

