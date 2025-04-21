const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

# Failed to predict input format
block main:
  let
    H, W = nextInt()
    c = Seq[H: nextString()]
  var
    ans = -1
  for i0 in H:
    for j0 in W:
      if c[i0][j0] == '#': continue
      var vis = Seq[H, W: false]
      proc f(i, j, ct:int) =
        vis[i][j] = true
        for (di, dj) in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
          let
            i2 = i + di
            j2 = j + dj
          if i2 notin 0 ..< H or j2 notin 0 ..< W or c[i2][j2] == '#':
            continue
          if i2 == i0 and j2 == j0 and ct >= 2:
            ans.max=ct + 1
          if vis[i2][j2]: continue
          f(i2, j2, ct + 1)
        vis[i][j] = false
        discard
      f(i0, j0, 0)
  echo ans


  discard

