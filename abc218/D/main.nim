const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(N:int, x:seq[int], y:seq[int]):
  var t = initTable[int, seq[int]]()
  for i in 0..<N:
    if x[i] notin t: t[x[i]] = newSeq[int]()
    t[x[i]].add(y[i])
  var s = initTable[(int, int), int]()
  for k, v in t:
    var v = v
    v.sort()
    for i in 0..<v.len:
      for j in i+1..<v.len:
        let p = (v[i], v[j])
        if p notin s: s[p] = 0
        s[p].inc
  var ans = 0
  for k, v in s:
    ans += v * (v - 1) div 2
  echo ans

  return

when not DO_TEST:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
else:
  discard

