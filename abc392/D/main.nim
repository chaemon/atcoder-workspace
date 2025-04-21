when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var A = Seq[N: seq[int]]
  for i in N:
    let K = nextInt()
    A[i] = Seq[K: nextInt()]
  var ans = 0.0
  for i in N:
    for j in i + 1 ..< N:
      let p = 1.0 / float(A[i].len * A[j].len)
      var
        ct = initTable[int, int]()
        s = 0.0
      for a in A[i]:
        ct[a].inc
      for a in A[j]:
        if a in ct:
          s += float(ct[a]) * p
      ans.max=s
  echo ans
  doAssert false

when not DO_TEST:
  solve()
else:
  discard

