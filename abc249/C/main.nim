const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, K:int, S:seq[string]):
  var s = collect(newSeq):
    for i in S.len: S[i].toSet
  var ans = 0
  for b in 2^N:
    var t = 0
    for c in 'a'..'z':
      var k = 0
      for i in N:
        if b[i] == 0: continue
        if c in S[i]: k.inc
      if k == K: t.inc
    ans.max= t
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, K, S)
else:
  discard

