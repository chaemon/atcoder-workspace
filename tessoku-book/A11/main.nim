when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, X:int, A:seq[int]):
  proc f(i:int):bool =
    if i == -1: return false
    X <= A[i]
  echo f.minLeft(-1 ..< N) + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, A)
else:
  discard

