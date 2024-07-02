when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  Pred A
  var
    ans:seq[(int, int)]
    vis = Seq[N: false]
  for u in N:
    if vis[u]: continue
    vis[u] = true
    if A[u] == u: continue
    var v = u
    var cycle = @[v]
    while true:
      if A[v] == u: break
      # i = vとj = A[v]を入れ替える
      v = A[v]
      cycle.add v
      vis[v] = true
    for i in countdown(cycle.len - 1, 1):
      ans.add (cycle[i], cycle[i - 1])
  echo ans.len
  for (i, j) in ans.mitems:
    if i > j: swap i, j
    echo i + 1, " ", j + 1
  Check(strm):
    Pred A
    let n = strm.nextInt()
    doAssert n <= N
    for _ in n:
      var i, j = strm.nextInt()
      i.dec
      j.dec
      swap(A[i], A[j])
    for i in N:
      check(A[i] == i)
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  let N = 10
  var A = (1 .. N).toSeq
  while true:
    debug N, A
    test(N, A)
    if not A.nextPermutation(): break
  discard

