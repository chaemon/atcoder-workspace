const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

proc calc(n, p, p2:int):tuple[z, p:mint] =
  var s:mint
  if p == 0 and p2 == 0:
    # 1 + 1 + .. + 1 (n + 1)個
    s = n + 1
  elif p == 1 and p2 == 0:
    # 0 + 1 + 2 + ... + n = n * (n + 1) / 2
    s = (n * (n + 1)) div 2
  elif p == 0 and p2 == 1:
    s = (n * (n + 1)) div 2
  else:
    #   0 * n + 1 * (n - 1) + ... + n * 0
    # = sum(i * (n - i)) for i in 0 .. n
    # = n * n * (n + 1) / 2 - n * (n + 1) * (2 * n + 1) / 6
    s = (mint(n) * n * (n + 1)) / 2 - (mint(n) * (n + 1) * (2 * n + 1)) / 6
  var z:mint
  if p2 == 1: z = 0
  elif p == 0: z = 1
  else: # p == 1 and p2 == 0
    z = n
  result = (z, s - z)

solveProc solve(N:int, a:seq[int]):
  var ans = mint(0)
  for end_pass in 0..1:
    var dp = Seq[2, 2:mint(0)] # prev_pass, zero_pass
    dp[0][0] = 1
    for i in N:
      var dp2 = Seq[2, 2:mint(0)]
      for prev_pass in 0..1:
        for zero_pass in 0..1:
          let cur = dp[prev_pass][zero_pass]
          if i == 0:
            if prev_pass == 1: continue
            for next_pass in 0..1:
              let (z, p) = calc(a[i], end_pass, 1 - next_pass)
              if zero_pass == 0:
                dp2[next_pass][0] += cur * p
                dp2[next_pass][1] += cur * z
              else:
                dp2[next_pass][1] += cur * (z + p)
          elif i < N - 1:
            for next_pass in 0..1:
              let (z, p) = calc(a[i], prev_pass, 1 - next_pass)
              if zero_pass == 0:
                dp2[next_pass][0] += cur * p
                dp2[next_pass][1] += cur * z
              else:
                dp2[next_pass][1] += cur * (z + p)
          elif i == N - 1:
            let (z, p) = calc(a[i], prev_pass, 1 - end_pass)
            if zero_pass == 0:
              ans += cur * z
            else:
              ans += cur * (z + p)
          else:
            assert false
      swap dp, dp2
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  for a in 10:
    for b in 10:
      for c in 10:
        for d in 10:
          for e in 10:
            let A = @[a, b, c, d, e]
            solve(A.len, A)

