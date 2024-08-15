when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var A = A
  for i in N:
    A[i] *= N
  let M = A.sum div N
  for i in N:
    A[i] -= M
  var
    cs = 0 & A.cumsummed
    m = cs.min
  for i in cs.len:
    if cs[i] == m:
      echo i + 1;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

