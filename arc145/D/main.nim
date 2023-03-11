const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

var
  s = Array[4 * 10^6: false]
  x = Array[-(2 * 10^7) .. 2 * 10^7: false]

proc gen(N:int):auto =
  var
    a = newSeq[int]()
    n = 1
    m = -int.inf
  while a.len < N:
    if not s[n]:
      for t in a:
        doAssert n * 2 - t < s.len
        s[n * 2 - t] = true
        m.max= n * 2 - t
      a.add n
    n.inc
  return (a, m)

solveProc solve(N:int, M:int):
  s.fill(false)
  if N == 1:
    echo M;return
  var
    (a, m) = gen(N - 1)
    s = a.sum mod N
    r = M mod N
  # m + 1以上のuで(s + u)mod N = rとなるものを探す
  var u = r - s
  while u <= m: u += N
  a.add u
  var s0 = a.sum
  doAssert (M - s0) mod N == 0
  let d = (M - s0) div N
  for a in a.mitems:
    a += d
  echo a.join(" ")
  Check(strm):
    x.fill(false)
    let s = Seq[N: strm.nextInt()].sorted
    for i in N - 1:
      doAssert s[i] < s[i + 1]
    for i in N:
      doAssert s[i] in -(10^7) .. 10^7
    for i in N:
      doAssert not x[s[i]]
      for j in 0 ..< i:
        x[s[i] * 2 - s[j]] = true
    #echo "check succeed!!"
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  #for N in 1..100:
  #  for M in - N * 10^6 .. N * 10^6:
  #    test(N, M)
  for N in 10^4 - 3 .. 10^4:
    let T = N * 10^6
    for M in [-T, -T + 1, -T + 2, T, T - 1, T - 2]:
      debug "test for", N, M
      test(N, M)
  discard
