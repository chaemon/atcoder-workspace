const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N: int, K: int, a: seq[int]):
  var ans = Seq[N: int]
  for i in K:
    var
      i = i
      x = Seq[int]
      idx = Seq[int]
    while i < N:
      x.add a[i]
      idx.add i
      i += K
    x.sort
    for i in idx.len:
      ans[idx[i]] = x[i]
  for i in ans.len - 1:
    if ans[i] > ans[i + 1]: echo NO; return
  echo YES
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, K, a)
else:
  discard

