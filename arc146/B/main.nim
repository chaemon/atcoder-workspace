const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

const B = 32

solveProc solve(N:int, M:int, K:int, A:seq[int]):
  var b = 0
  for i in 0 ..< B << 1:
    # b[i] = 1にしてみる
    b[i] = 1
    v := Seq[int]
    for j in N:
      if b >= A[j]:
        v.add b - A[j]
      else:
        # b[t] = 1なる桁t >= iでは1にしなくてはならない
        var
          f = 0
          found = false
        for t in i ..< B << 1:
          if found:
            f[t] = b[t]
          elif A[j][t] == 1:
            f[t] = 1
          elif b[t] == 1 and A[j][t] == 0:
            f[t] = 1; found = true
        if not found: v.add 0
        else: v.add f - A[j]
    v.sort()
    if v.len >= K and v[0 ..< K].sum <= M:
      continue
    else:
      b[i] = 0
      #v := Seq[int]
      #for j in N:
      #  v.add (A[j] or b) - A[j]
      #v.sort()
      #doAssert v[0 ..< K].sum <= M
  echo b
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, K, A)
else:
  discard

