when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search


solveProc solve(N:int, K:int, A:seq[int]):
  proc f(t:int):bool =
    # t個ずつ食べると残りがあるかどうか
    s := 0
    for i in N:
      if A[i] > t: s += t
      else: s += A[i]
    if s <= K: return true
    else: return false
  var u = f.maxRight(0 .. A.max + 1)
  var A = A
  # u個ずつ食べる
  s := 0
  for a in A.mitems:
    if a >= u:
      s += u
      a -= u
    else:
      s += a
      a = 0
  doAssert s <= K
  var
    K = K - s
    i = 0
  while K > 0:
    if A[i] > 0:
      A[i].dec
      K.dec
    i.inc
  echo A.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

