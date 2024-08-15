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
solveProc solve(N:int, L:seq[int], R:seq[int]):
  let
    Lsum = L.sum
    Rsum = R.sum
  if 0 notin Lsum .. Rsum:
    echo NO;return
  var
    X = L
    k = 0 - Lsum
  for i in N:
    if k > 0:
      let m = min(k, R[i] - L[i])
      k -= m
      X[i] += m
  echo YES
  echo X.join(" ")
  doAssert X.sum == 0
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, L, R)
else:
  discard

