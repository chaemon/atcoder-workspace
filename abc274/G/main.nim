when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/graph/hopcroft_karp

solveProc solve(H:int, W:int, S:seq[string]):
  id := Seq[H, W: (r: -1, c: -1)]
  row_ct := 0
  for i in H:
    for j in W:
      if S[i][j] == '#': continue
      if id[i][j].r != -1: continue
      var (i, j) = (i, j)
      while true:
        if j notin 0 ..< W or S[i][j] == '#': break
        id[i][j].r = row_ct
        j.inc
      row_ct.inc
  col_ct := 0
  for j in W:
    for i in H:
      if S[i][j] == '#': continue
      if id[i][j].c != -1: continue
      var (i, j) = (i, j)
      while true:
        if i notin 0 ..< H or S[i][j] == '#': break
        id[i][j].c = col_ct
        i.inc
      col_ct.inc
  var hk = initHopcroftKarp(row_ct, col_ct)
  for i in H:
    for j in W:
      if S[i][j] == '#': continue
      let (r, c) = id[i][j]
      hk.addEdge(r, c)
  let p = hk.minimumVertexCover()
  echo p[0].len + p[1].len
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

