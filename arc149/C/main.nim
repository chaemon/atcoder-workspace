when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/eratosthenes


solveProc solve(N:int):
  var A: seq[seq[int]]
  if N == 3:
    A = @[
    @[5, 3, 1],
    @[9, 7, 8],
    @[6, 2, 4]]
  elif N == 4:
    A = @[
    @[1, 5, 7, 11],
    @[3, 9, 15,13],
    @[6,12, 10, 2],
    @[4, 8, 14,16]]
  elif N == 5:
    A = @[
    @[1 , 5, 7,11,13],
    @[17,19,23,21,25],
    @[ 3, 9,15,24, 2],
    @[ 6,12,18,22, 4],
    @[ 8,10,14,16,20]]
  elif N mod 2 == 0:
    var listed = initSet[int]()
    A = Seq[N, N: -1]
    var
      t = 3
      c = N div 2 - 1
    for j in 0 ..< N:
      A[c][j] = t
      listed.incl t
      doAssert t <= N * N
      t += 6
    t = 6
    for j in 0 ..< N:
      A[c + 1][j] = t
      listed.incl t
      doAssert t <= N * N
      t += 6
    block:
      l := newSeq[int]()
      for d in 1 .. N * N >> 2:
        if d in listed: continue
        l.add d
      for d in 2 .. N * N >> 2:
        if d in listed: continue
        l.add d
      l.reverse
      for i in N:
        for j in N:
          if A[i][j] == -1:
            A[i][j] = l.pop
  elif N mod 2 == 1:
    var listed = initSet[int]()
    A = Seq[N, N: -1]
    var
      t = 3
      c = (N + 1) div 2 - 1
      d = c
    for j in 0 ..< N:
      if j < (N + 1) div 2:
        A[c][j] = t
      else:
        A[c - 1][j] = t
      listed.incl t
      t += 6
    doAssert t <= N * N
    t = 6
    for j in 0 ..< N:
      if j < (N + 1) div 2:
        A[c + 1][j] = t
      else:
        A[c][j] = t
      listed.incl t
      t += 6
    doAssert t <= N * N
    block:
      l := newSeq[int]()
      for d in 1 .. N * N >> 2:
        if d in listed: continue
        l.add d
      for d in 2 .. N * N >> 2:
        if d in listed: continue
        l.add d
      l.reverse
      for i in N:
        for j in N:
          if A[i][j] == -1:
            A[i][j] = l.pop
  for a in A:
    echo a.join(" ")
  block test:
    var listed = initSet[int]()
    for i in N:
      for j in N:
        doAssert A[i][j] in 1..N^2
        doAssert A[i][j] notin listed
        listed.incl A[i][j]

  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

