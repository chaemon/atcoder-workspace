when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

# Failed to predict input format
solveProc solve():
  let N, M = nextInt()
  var a = Seq[N, N: false]
  for _ in M:
    let k = nextInt()
    var x = Seq[k: nextInt() - 1]
    for i in x.len:
      for j in i + 1 ..< x.len:
        a[x[i]][x[j]] = true
        a[x[j]][x[i]] = true
  for i in N:
    for j in i + 1 ..< N:
      if not a[i][j] : echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

