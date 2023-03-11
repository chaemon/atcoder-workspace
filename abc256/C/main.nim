const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(h:seq[int], w:seq[int]):
  # a b e
  # c d f
  # g i j
  ans := 0
  for a in 1 .. 30:
    for b in 1 .. 30:
      for c in 1 .. 30:
        for d in 1 .. 30:
          let
            e = h[0] - a - b
            f = h[1] - c - d
            g = w[0] - a - c
            i = w[1] - b - d
          if e <= 0 or f <= 0 or g <= 0 or i <= 0: continue
          let
            j0 = h[2] - g - i
            j1 = w[2] - e - f
          if j0 <= 0 or j1 <= 0: continue
          if j0 != j1: continue
          ans.inc
  echo ans

when not DO_TEST:
  var h = newSeqWith(3, nextInt())
  var w = newSeqWith(3, nextInt())
  solve(h, w)
else:
  discard

