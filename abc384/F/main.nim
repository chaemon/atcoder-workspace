when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var
    k = 0
    a = newSeq[int]() # 2^kで割り切れるものの和
  while true:
    let p = 2^k
    if p > 10^7: break
    var
      t = initTable[int, tuple[s, n: int]]()
      s = 0
    for i in N:
      let r = A[i] mod p
      t[r].s += A[i]
      t[r].n.inc
      var r2 = if r == 0: 0 else: p - r
      if r2 in t:
        s += t[r2].s + t[r2].n * A[i]
      if r notin t:
        t[r] = (0, 0)
    a.add s
    k.inc
  var ans = 0
  for k in a.len:
    let p = 2^k
    ans += a[k] div p
    if k + 1 < a.len:
      ans -= a[k + 1] div p
    # pで割り切れるがp*2で割り切れないのを数える
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

