when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/hopcroft_karp

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, M:int, A:seq[seq[int]]):
  var A = A
  for i in N:
    for j in M:
      A[i][j].dec
  var e = Seq[N, N: 0]
  for i in N:
    for j in M:
      e[i][A[i][j]].inc
  var ans = Seq[N, M:int]
  for x in M:
    var hk = initHopcroftKarp(N, N)
    for i in N:
      for j in N:
        for _ in e[i][j]:
          hk.addEdge(i, j)
    let v = hk.maximum_matching()
    if v.len != N:
      doAssert x == 0
      echo No;return
    for (s, t) in v:
      ans[s][x] = t
      e[s][t].dec
  for i in N:
    for j in M:
      ans[i][j].inc
  echo Yes
  for i in ans.len:
    echo ans[i].join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, A)
else:
  discard

