const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, S:int, A:seq[int]):
  var Asum = Seq[float]
  for i in countdown(N - 1, 0):
    if i == N - 1:
      Asum.add A[i].float
    else:
      Asum.add Asum[^1] + A[i]
  ans := float.inf
  for i in N:
    var
      qmin = 0.0
      qmax = float.inf
    for j in N:
      if i == j: continue
      # (j + 1) * p + q >= Asum[j]
      # (i + 1) * p + q == Asum[i]
      # (j - i) * p >= Asum[j] - Asum[i]
      let
        p0 = (Asum[j] - Asum[i]) / (j - i)
        q0 = Asum[i] - (i + 1) * p0
      if i - j > 0: # q <= **
        qmin.max= q0
      else: # q >= **
        qmax.min= q0
    if qmin <= qmax:
      for q in [qmin, qmax]:
        if q == float.inf: continue
        let p = (Asum[i] - q) / (i + 1)
        ## check
        #for i in N:
        #  doAssert q >= 0.0
        #  doAssert (i + 1) * p + q >= Asum[i]
        ans.min= p * S + q * M
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, S, A)
else:
  discard

