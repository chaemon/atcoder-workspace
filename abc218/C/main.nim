const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, S:seq[string], T:seq[string]):
  proc rotate(S:seq[string]):seq[string] =
    result = S
    for i in N:
      for j in N:
        result[i][j] = S[N - 1 - j][i]
  var cS, cT = 0
  for i in N: cS += S[i].count '#'
  for i in N: cT += T[i].count '#'
  if cS != cT: echo NO;return
  var Ti, Tj = 0
  block loop:
    for i in 0..<N:
      for j in 0..<N:
        if T[i][j] == '#': Ti = i; Tj = j; break loop
  var X = S
  for d in 4:
    var xi, xj = 0
    block loop:
      for i in 0..<N:
        for j in 0..<N:
          if X[i][j] == '#': xi = i; xj = j; break loop
    block loop:
      var valid = true
      for i in N:
        for j in N:
          if X[i][j] == '#':
            let i2 = i - xi + Ti
            let j2 = j - xj + Tj
            if i2 notin 0..<N or j2 notin 0..<N: valid = false; break loop
            if T[i2][j2] != '#': valid = false; break
      if valid:
        echo YES;return
    X = X.rotate
  echo NO
  return

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  var T = newSeqWith(N, nextString())
  solve(N, S, T)
else:
  discard

