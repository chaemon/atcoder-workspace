when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve():
  let H, W = nextInt()
  var x, y = nextInt()
  let N = nextInt()
  var rows, cols = initTable[int, seq[int]]()
  for i in N:
    let r, c = nextInt()
    rows[r].add c
    cols[c].add r
  for k, v in rows.mpairs:
    v.sort
  for k, v in cols.mpairs:
    v.sort
  let Q = nextInt()
  for _ in Q:
    let
      d = nextString()
      l = nextInt()
    if d[0] == 'U':
      # x -> x - l
      var wall = 1
      if y in cols:
        var i = cols[y].lowerBound(x)
        i.dec
        if i >= 0:
          wall = cols[y][i] + 1
      x = max(x - l,  wall)
    elif d[0] == 'D':
      var wall = H
      if y in cols:
        var i = cols[y].lowerBound(x)
        #i.dec
        if i < cols[y].len:
          wall = cols[y][i] - 1
      x = min(x + l, wall)
    elif d[0] == 'L':
      # y -> y - l
      var wall = 1
      if x in cols:
        var i = rows[x].lowerBound(y)
        i.dec
        if i >= 0:
          wall = rows[x][i] + 1
      y = max(y - l, wall)
    elif d[0] == 'R':
      var wall = W
      if x in cols:
        var i = cols[x].lowerBound(y)
        #i.dec
        if i < rows[x].len:
          wall = rows[x][i] - 1
      y = min(y + l, wall)
    echo x, " ", y
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

