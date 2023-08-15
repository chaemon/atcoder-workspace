when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let N, M = nextInt()
  let
    A = N @ nextInt()
    B = M @ nextInt()
  var
    C = (A & B).sorted
    t = initTable[int, int]()
  for i in C.len:
    t[C[i]] = i
  var
    a, b = @(int)
  for i in N:
    a.add t[A[i]] + 1
  for i in M:
    b.add t[B[i]] + 1
  echo a.join(" ")
  echo b.join(" ")
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

