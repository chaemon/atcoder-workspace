when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitset

const B = 10^9 + 5
#const B = 10^5

var u: BitSet[B * 2 + 1]

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, X:int, A:seq[int]):
  var X = X
  if X < 0: X = -X
  for i in N:
    debug i, N, A[i] + B
    u[A[i] + B] = 1
  var v = u shl X
  #if ((u shl X) and u).any():
  #  echo YES
  #else:
  #  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, A)
else:
  discard
