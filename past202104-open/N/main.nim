include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, H:int, a:seq[int], b:seq[int]) =
  var
    H = H
    v:seq[(float, int)]
    ans = 0
  for i in N:
    v.add (a[i] / b[i], i)
  v.sort(SortOrder.Descending)
  var dp = H + 1 @ -int.inf
  dp[H] = 0
  for (f, i) in v:
    for h in 0 .. H:
      if dp[h] == -int.inf: continue
      let
        h2 = h - b[i]
        d = dp[h] + a[i] * h
      ans.max=d
      if h2 >= 0:
        dp[h2].max=d
  echo ans
  return

block:
  var N = nextInt()
  var H = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, H, a, b)
