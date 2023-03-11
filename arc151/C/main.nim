when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

proc mex(v:seq[int]):int =
  var v = v
  v.sort
  v = v.deduplicate(isSorted = true)
  for i in v.len:
    if v[i] != i: return i
  return v.len

proc calc_fast(n, l, r:int):int =
  if n == 0: return 0
  if l == 2 and r == 2:
    return n mod 2
  elif l == 2 or r == 2:
    return n
  elif l == r: return 1
  elif l != r: return 0
  else:
    doAssert false
  
proc test() =
  const B = 100
  var
    dp = Seq[B, 3, 3: int]
    vis = Seq[B, 3, 3: false]
  proc calc(n, l, r:int):int =
    t =& dp[n][l][r]
    if vis[n][l][r]: return t
    vis[n][l][r] = true
    var ans = Seq[int]
    for x in 0 .. 1:
      for i in n:
        if i == 0 and l == x:
          continue
        elif i == n - 1 and r == x:
          continue
        ans.add calc(i, l, x) xor calc(n - i - 1, x, r)
    t = ans.mex
    return t
  for l in 0 .. 2:
    for r in 0 .. 2:
      for n in 0 ..< B:
        debug n, l, r, calc(n, l, r)
        doAssert calc(n, l, r) == calc_fast(n, l, r)
  echo "test complete!!"

#test()

solveProc solve(N:int, M:int, X:seq[int], Y:seq[int]):
  ans := 0
  if M == 0:
    ans.xor= calc_fast(N, 2, 2)
  else:
    ans.xor= calc_fast(X[0], 2, Y[0])
    for i in M - 1:
      # X[i] .. X[i + 1]
      ans.xor= calc_fast(X[i + 1] - X[i] - 1, Y[i], Y[i + 1])
      discard
    ans.xor= calc_fast(N - 1 - X[M - 1], 2, Y[M - 1])
  if ans == 0:
    echo "Aoki"
  else:
    echo "Takahashi"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt() - 1
    Y[i] = nextInt()
  solve(N, M, X, Y)
else:
  discard

