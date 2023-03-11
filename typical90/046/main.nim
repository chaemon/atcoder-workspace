const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, A:seq[int], B:seq[int], C:seq[int]):
  var a, b, c = Seq[46: 0]
  for i in N:
    a[A[i] mod 46].inc
    b[B[i] mod 46].inc
    c[C[i] mod 46].inc
  ans := 0
  for r in 46:
    for s in 46:
      let t = (46 - r - s).floorMod 46
      ans += a[r] * b[s] * c[t]
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  solve(N, A, B, C)
