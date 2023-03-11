const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var p = Seq[tuple[c, b:int]]
  for b in 1..2^N-1:
    p.add((nextInt(), b))
  p.sort

  var v = Seq[int]
  var t = Seq[int]
  var ans = 0
  for (c, b) in p:
    var b = b
    for j in v.len:
      if b[t[j]] == 1: b = b xor v[j]
    if b == 0: continue
    v.add b
    t.add b.countTrailingZeroBits
    ans += c
  echo ans
  discard

when not DO_TEST:
  solve()
else:
  discard

