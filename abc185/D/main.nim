include atcoder/extra/header/chaemon_header


proc solve() =
  let N, M = nextInt()
  var A = Seq(M, nextInt())
  A.sort()
  A = 0 & A & N + 1
  var ds = newSeq[int]()
  for i in 0..<A.len-1:
    let d = A[i + 1] - A[i] - 1
    if d > 0: ds.add(d)
  if ds.len == 0:
    echo 0;return
  let m = ds.min
  var ans = 0
  for d in ds:
    ans += (d + m - 1) div m
  echo ans
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
