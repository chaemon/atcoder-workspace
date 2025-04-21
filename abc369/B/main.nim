when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], S:seq[string]):
  var
    ans = 0
    Lpos = -1
    Rpos = -1
  for i in N:
    case S[i][0]:
    of 'L':
      if Lpos != -1:
        ans += abs(Lpos - A[i])
      Lpos = A[i]
    of 'R':
      if Rpos != -1:
        ans += abs(Rpos - A[i])
      Rpos = A[i]
    else:
      doAssert false
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var S = newSeqWith(N, "")
  for i in 0..<N:
    A[i] = nextInt()
    S[i] = nextString()
  solve(N, A, S)
else:
  discard

