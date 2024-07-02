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
solveProc solve(N:int, K:int, A:seq[int]):
  var A = A.sorted
  let S = A.sum
  if K > 0: # K > 0のとき→正順
    echo YES
    echo A.join(" ")
  else: # K <= 0のときはすべてK以上→逆順に並べる
    A.reverse
    if S < K:
      echo NO
    else:
      echo YES
      echo A.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

