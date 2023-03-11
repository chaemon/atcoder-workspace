import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL 
Please use Nim-ACL
Please use Nim-ACL

const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/maxflow


# Failed to predict input format
solveProc solve(H, W, C:int, A:seq[seq[int]]):
  var st = initMaxFlow[int](H * W + 2)
  proc id(i, j:int):int = W * i + j
  let
    s = H * W
    t = s + 1
  var S =  0
  for i in H:
    for j in W:
      S += A[i][j]
      st.addEdge(id(i, j), t, A[i][j])
      block:
        let (i2, j2) = (i + 1, j + 1)
        if i2 in 0..<H and j2 in 0..<W:
          st.addEdge(id(i2, j2), id(i, j), C)
        else:
          st.addEdge(s, id(i, j), C)
      block:
        let (i2, j2) = (i + 1, j - 1)
        if i2 in 0..<H and j2 in 0..<W:
          st.addEdge(id(i2, j2), id(i, j), C)
        else:
          st.addEdge(s, id(i, j), C)
  echo S - st.flow(s, t)
  discard

when not DO_TEST:
  let H, W, C = nextInt()
  let A = Seq[H, W:nextInt()]
  solve(H, W, C, A)
else:
  discard

