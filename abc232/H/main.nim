const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import std/streams

template `&`*[T](v:seq[T]):auto = v.mitems

solveProc solve(H:int, W:int, a:int, b:int):
  proc solve_H2(W, a, b:int):seq[tuple[x, y:int]] =
    if (a, b) == (1, 0):
      for j in 0..<W: result.add (0, j)
      for j in 0..<W << 1: result.add (1, j)
    else:
      for j in 0 ..< b:
        result.add (0, j)
        result.add (1, j)
      # avoid (a, b)
      if a == 0:
        result.add (1, b)
      elif a == 1:
        result.add (0, b)
      else:
        assert false
      for j in b + 1 ..< W:
        result.add (0, j)
      for j in b + 1 ..< W << 1:
        result.add (1, j)
      result.add (a, b)
    discard

  proc transpose(v:seq[tuple[x, y:int]]):auto =
    result = v
    for v in &result: swap v.x, v.y
  proc symmetryW(v:seq[tuple[x, y:int]], H, W:int):auto =
    result = v
    for v in &result:
      v.y = W - 1 - v.y
  proc solve_sub(H, W, a, b:int):seq[tuple[x, y:int]] =
    doAssert a in 0..<H and b in 0..<W
    if H == 2:
      return solve_H2(W, a, b)
    elif W == 2:
      return solve_sub(W, H, b, a).transpose
    if a == 0:
      # b != 0
      return solve_sub(W, H, b, a).transpose
    else:
      for j in 0..<W:
        result.add (0, j)
      if (a, b) == (1, W - 1):
        var v = solve_sub(H - 1, W, 0, 1).symmetryW(H - 1, W).reversed
        for (x, y) in &v:
          x.inc
        result &= v
      else:
        var v = solve_sub(H - 1, W, a - 1, W - 1 - b).symmetryW(H - 1, W)
        for (x, y) in &v:
          x.inc
        result &= v
  var v = solve_sub(H, W, a, b)
  for (x, y) in &v:
    echo x + 1, " ", y + 1
  Check:
    var v = collect(newSeq):
      for i in 0..<H * W: (x:strm.nextInt() - 1, y:strm.nextInt() - 1)
    var vis = Seq[H, W:false]
    check v[0] == (0, 0)
    for i,(x, y) in v:
      check not vis[x][y]
      vis[x][y] = true
      if i > 0:
        let (x2, y2) = v[i - 1]
        check max(abs(x - x2), abs(y - y2)) == 1
    check v[^1] == (a, b)

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var a = nextInt() - 1
  var b = nextInt() - 1
  solve(H, W, a, b)
else:
  const B = 20
  for H in 2..B:
    for W in 2..B:
      for a in 0..<H:
        for b in 0..<W:
          if (a, b) == (0, 0): continue
          test(H, W, a, b)
