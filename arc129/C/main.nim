const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int):
  var N = N
  a := Seq[int]
  while N > 0:
    n := 0
    while true:
      let
        n2 = n + 1
        t = n2 * (n2 - 1) div 2
      if t > N:
        break
      n = n2
    a.add n
    N -= n * (n - 1) div 2
  doAssert a.len <= 7
  #debug a
  var
    ans = Seq[int]
    r = Seq[int]
  for i in a.len:
    s := a[i]
    if i == 0: s.dec
    for _ in s:
      r.add i
  var
    R = 0
    p = 1
  for i in r.len:
    # R + p * d mod 7 = r[i] となるdを求める
    for d in 1..7:
      if (R + p * d) mod 7 == r[i]:
        ans.add d
        R += d * p
        R.mod=7
        break
    p *= 10
    p.mod=7
  S := ans.join()
  S.reverse
  echo S
  Check(strm):
    let S = strm.nextString()
    doAssert S.len <= 10^6
    c := 0
    for l in 0..<S.len:
      for r in l+1..S.len:
        if S[l..<r].parseInt mod 7 == 0:
          c.inc
    doAssert c == N
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  for N in 1..1000000:
    debug N
    solve(N)
