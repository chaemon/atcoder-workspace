const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

var dir = [[0, 1], [0, -1], [1, 0], [-1, 0]]

solveProc solve(A:seq[seq[int]]):
  var ans = 0
  for b in 2^16:
    var B = Seq[4, 4:0]
    for i in 4:
      for j in 4:
        if b[i * 4 + j] == 1: B[i][j] = 1
    # すべての家が掘りの内部にあるかどうか？
    var ok = true
    block:
      for i in 4:
        for j in 4:
          if A[i][j] == 1 and B[i][j] == 0:
            ok = false
    if not ok: continue
    # 堀の連結成分が1つか？
    block check:
      vis := Seq[4, 4: -1]
      ct := 0
      proc dfs(x, y:int) =
        if vis[x][y] != -1: return
        vis[x][y] = ct
        for (dx, dy) in dir:
          let
            x2 = x + dx
            y2 = y + dy
          if x2 notin 0 ..< 4 or y2 notin 0 ..< 4:continue
          if B[x2][y2] != 1: continue
          if vis[x2][y2] != -1: continue
          dfs(x2, y2)
      for x in 4:
        for y in 4:
          if B[x][y] == 0 or vis[x][y] != -1: continue
          if ct >= 1: ok = false;break check
          dfs(x, y)
          ct.inc
    if not ok: continue
    # すべての堀でない点が外部に接続するか？
    block check:
      vis := Seq[4, 4: -1]
      ct := 0
      state := 0
      proc dfs(x, y:int) =
        if vis[x][y] != -1: return
        vis[x][y] = ct
        for (dx, dy) in dir:
          let
            x2 = x + dx
            y2 = y + dy
          if x2 notin 0 ..< 4 or y2 notin 0 ..< 4:
            state = 1;continue
          if B[x2][y2] != 0: continue
          if vis[x2][y2] != -1: continue
          dfs(x2, y2)
      for x in 4:
        for y in 4:
          if B[x][y] == 1 or vis[x][y] != -1: continue
          state = 0
          dfs(x, y)
          if state == 0:
            ok = false;break check
          ct.inc
    if not ok: continue
    ans.inc
  echo ans
  return

when not DO_TEST:
  var A = newSeqWith(4, newSeqWith(4, nextInt()))
  solve(A)
else:
  discard

