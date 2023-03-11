const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:seq[string]):
  var dir = [(0, 1), (1, 0), (1, 1), (1, -1)]
  for x in N:
    for y in N:
      for d in dir.len:
        var
          ct = 0
          x = x
          y = y
          ok = true
        for i in 6:
          if x notin 0 ..< N or y notin 0 ..< N:
            ok = false
            break
          if S[x][y] == '.': ct.inc
          x += dir[d][0]
          y += dir[d][1]
        if not ok: continue
        if ct <= 2: echo YES;return
  echo NO
  discard

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

