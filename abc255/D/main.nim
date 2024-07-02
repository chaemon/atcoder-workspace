const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, Q:int, A:seq[int], X:seq[int]):
  var
    v = A.sorted
    a = collect(newSeq):
      for i in Q: (X:X[i], i:i)
    ans = Seq[Q: int]
    m_sum = 0 # Xより小さい
    m_num = 0
    p_sum = A.sum # X以上
    p_num = N
    t = 0
    # t ..< NがMinus
  a.sort
  for (X, i) in a:
    # X以下のものをplusからminusに
    while t < N and v[t] < X:
      p_sum -= v[t]
      p_num.dec
      m_sum += v[t]
      m_num.inc
      t.inc
    ans[i] = X * m_num - m_sum + p_sum - X * p_num
  echo ans.join("\n")
  discard

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var X = newSeqWith(Q, nextInt())
  solve(N, Q, A, X)
else:
  discard

