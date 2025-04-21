when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, M:int, A:seq[int], B:seq[string]):
  var s = initSet[int]()
  for i in M:
    if B[i][0] == 'F':
      echo NO
    else:
      if A[i] notin s:
        echo YES
        s.incl A[i]
      else:
        echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, "")
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextString()
  solve(N, M, A, B)
else:
  discard

