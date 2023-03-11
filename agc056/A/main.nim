const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int):
  var S = Seq[N:".".repeat(N)]
  var a5 = [
    "##.#.",
    "#.#.#",
    "#.##.",
    ".#.##",
    ".##.#"]
  var a6 = [
    "###...",
    "...###",
    "###...",
    "...###",
    "###...",
    "...###"]
  var a7 = [
    ".##.#..",
    "..#.##.",
    "#.#..#.",
    "#..#.#.",
    "#..#..#",
    ".#.#..#",
    ".#..#.#",]
  proc build(i, j, n:int) =
    if n == 5:
      for i2 in 0..<n:
        for j2 in 0..<n:
          S[i + i2][j + j2] = a5[i2][j2]
    elif n == 6:
      for i2 in 0..<n:
        for j2 in 0..<n:
          S[i + i2][j + j2] = a6[i2][j2]
    elif n == 7:
      for i2 in 0..<n:
        for j2 in 0..<n:
          S[i + i2][j + j2] = a7[i2][j2]
    else:
      assert false
  let r = N mod 3
  var i = 0
  if r == 0:
    build(0, 0, 6)
    i += 6
  elif r == 1:
    build(0, 0, 7)
    i += 7
  elif r == 2:
    build(0, 0, 5)
    i += 5
  while i < N:
    assert S[i - 1][i - 1] == '#'
    S[i - 1][i - 1] = '.'
    S[i - 1][i] = '#'
    S[i][i - 1] = '#'
    for i2 in 0..<3:
      for j2 in 0..<3:
        if i2 == 0 and j2 == 0: continue
        S[i + i2][i + j2] = '#'
    i += 3
  for s in S:
    echo s

  Check:
    var s = Seq[string]
    for i in N:
      s.add strm.nextString()
    #let s = Seq[N: strm.nextString()]
    for i in N:
      ct := 0
      for j in N:
        if s[i][j] == '#': ct.inc
      check(ct == 3)
    for j in N:
      ct := 0
      for i in N:
        if s[i][j] == '#': ct.inc
      check(ct == 3)
    var dir = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    var vis = Seq[N, N: false]
    proc dfs(i, j:int) =
      if vis[i][j]: return
      vis[i][j] = true
      for (x, y) in dir:
        let
          i2 = i + x
          j2 = j + y
        if i2 notin 0..<N or j2 notin 0..<N or s[i2][j2] == '.': continue
        dfs(i2, j2)
    ct := 0
    for i in N:
      for j in N:
        if s[i][j] == '.': continue
        if vis[i][j]: continue
        ct.inc
        dfs(i, j)
    check(ct == N)
  discard

when not DO_TEST:
  var N = nextInt()
  discard solve(N)
else:
  for N in 6..500:
    echo "test for ", N
    test(N)
  discard

