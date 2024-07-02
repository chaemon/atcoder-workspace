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
    vis = Seq[N * 3: false]
    ans = 0
  proc calc() =
    var i = 0
    while i < N * 3 and vis[i]:
      i.inc
    if i == N * 3:
      ans.inc
      return
    vis[i] = true
    for j in i + 1 ..< N * 3:
      if vis[j]: continue
      vis[j] = true
      for k in j + 1 ..< N * 3:
        if vis[k]: continue
        vis[k] = true
        let v = [A[i], A[j], A[k]].sorted
        if v[0] + v[1] > v[2]:
          calc()
        vis[k] = false
      vis[j] = false
    vis[i] = false
  calc()
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(3*N, nextInt())
  solve(N, A)
else:
  discard

