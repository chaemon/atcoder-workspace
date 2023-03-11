const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/string/rolling_hash

solveProc solve(N:int, S:string, T:string):
  var T0, T1, T2 = T
  # R <-> G
  for t in T0.mitems:
    if t == 'R': t = 'G'
    elif t == 'G': t = 'R'
  # G <-> B
  for t in T1.mitems:
    if t == 'G': t = 'B'
    elif t == 'B': t = 'G'
  # B <-> R
  for t in T2.mitems:
    if t == 'B': t = 'R'
    elif t == 'R': t = 'B'
  var
    r = initRollingHash(S)
    r0 = initRollingHash(T0)
    r1 = initRollingHash(T1)
    r2 = initRollingHash(T2)
    ans = 0

  for i in 2 * N - 1:
    if i < N:
      let l = i + 1
      var h = r[0 ..< l]
      if r0[^l .. ^1] == h or r1[^l .. ^1] == h or r2[^l .. ^1] == h:
        ans.inc
    else:
      let l = 2 * N - 1 - i
      var h = r[^l .. ^1]
      if r0[0 ..< l] == h or r1[0 ..< l] == h or r2[0 ..< l] == h:
        ans.inc
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
