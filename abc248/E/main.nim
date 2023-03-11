const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, K:int, X:seq[int], Y:seq[int]):
  if K == 1:
    echo "Infinity";return
  var ans = 0
  for i in N:
    for j in i+1..<N:
      var
        ok = true
        ct = 2
      for k in N:
        if i == k or j == k: continue
        if (Y[i] - Y[j]) * (X[i] - X[k]) == (Y[i] - Y[k]) * (X[i] - X[j]):
          if k < j:
            ok = false
            break
          ct.inc
      if not ok: continue
      if ct >= K:
        ans.inc
  echo ans

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, K, X, Y)
else:
  discard

