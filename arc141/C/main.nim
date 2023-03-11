const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, P:seq[int], Q:seq[int]):
  var
    k = 0
    posP, posQ = Seq[N*2: int]
    ok = true
    listed = "?".repeat(N * 2)
  for i in P.len:
    posP[P[i]] = i
    posQ[Q[i]] = i
  while k < N * 2:
    # Pにおいてp番目がopenとわかる
    listed[P[k]] = '('
    var a = @[P[k]]
    while true:
      # Qにおいてaの順序が正しいか?
      for i in a.len - 1:
        if posQ[a[i]] <= posQ[a[i + 1]]:
          echo -1;return
      for i in a.len:
        listed[a[i]] = '('
      var b:seq[int]
      for i in posQ[a[^1]] ..< N * 2 - k:
        if listed[Q[i]] == '?':
          listed[Q[i]] = ')'
          b.add Q[i]
      if a.len > b.len: echo -1;return
    # Qにおけるuの右側の未定はすべて閉じカッコとわかる
  
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(2*N, nextInt() - 1)
  var Q = newSeqWith(2*N, nextInt() - 1)
  solve(N, P, Q)
else:
  discard

