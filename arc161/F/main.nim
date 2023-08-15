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
solveProc solve(N:int, D:int, A:seq[int], B:seq[int], A_DN:int, B_DN:int):
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var D = nextInt()
    var A = newSeqWith(2, 0)
    var B = newSeqWith(2, 0)
    for i in 0..<2:
      A[i] = nextInt()
      B[i] = nextInt()
    var A_DN = nextInt()
    var B_DN = nextInt()
    solve(N, D, A, B, A_DN, B_DN)
else:
  discard

