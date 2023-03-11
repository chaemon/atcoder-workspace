const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

proc is_valid(d:int):bool =
  assert d > 0
  var d = d
  while d > 0:
    let r = d mod 10
    if r notin 1..3: return false
    d.div=10
  return true

solveProc solve(N:int):
  var N = N
  var d = Seq[int]
  while N > 0:
    d.add(N mod 10)
    N.div=10
  proc test(n:int):bool =
    var dp = Seq[n + 1, n + 1:false] # carry, num
    for t in n..n*3:
      let r = t mod 10
      if r != d[0]: continue
      let c = t div 10
      dp[c][n] = true
    for i in 1..<d.len:
      var dp2 = Seq[n + 1, n + 1:false]
      for c in 0..n:
        for k in 1..n:
          if not dp[c][k]: continue
          for c2 in 0..n:
            let x = c2 * 10 + d[i] - c
            if x < 0: continue
            var s = 1
            if i == d.len - 1: s = 0
            for k2 in s..k:
              if x in k2 .. k2 * 3:
                dp2[c2][k2] = true
      swap dp, dp2
    for k in 0..n:
      if dp[0][k]: return true
    return false
  var n = 1
  while true:
    if test(n):
      echo n;return
    n.inc
  Naive:
    if is_valid(N): echo 1;return
    for a in 1..N:
      if not is_valid(a): continue
      let b = N - a
      if b <= 0 or not is_valid(b): continue
      debug a, b
      echo 2;return
    for a in 1..N:
      if not is_valid(a): continue
      for b in 1..N:
        if not is_valid(b): continue
        let c = N - a - b
        if c <= 0 or not is_valid(c): continue
        echo 3; return
    for a in 1..N:
      if not is_valid(a): continue
      for b in 1..N:
        if not is_valid(b): continue
        for c in 1..N:
          if not is_valid(c): continue
          let d = N - a - b - c
          if d <= 0 or not is_valid(d): continue
          debug a, b, c, d
          echo 4; return
    doAssert false
  discard

when DO_TEST:
  for N in 90909..10000000:
    debug N
    test(N)

when not DO_TEST:
  let T = nextInt()
  for i in T:
    let N = nextInt()
    solve(N)

